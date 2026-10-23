//
//  NetworkClient.swift
//  MangaHub
//

import Foundation

/// Define el comportamiento que debe cumplir cualquier cliente de red.

/// Gracias a este protocolo podemos cambiar la implementación
/// (URLSession, Alamofire, Mock para tests...)
/// sin modificar el resto de la aplicación.

/// Define las operaciones que debe ofrecer cualquier cliente de red.
nonisolated protocol NetworkClient: Sendable {
    
    /// Envía un endpoint y decodifica la respuesta al tipo solicitado.
    @discardableResult
    func send<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as type: T.Type
    ) async throws -> T
    
    func send(_ endpoint: Endpoint) async throws
}

/// Implementación del cliente de red utilizando URLSession.
/// Será el único encargado de comunicarse con la API REST.

nonisolated final class URLSessionNetworkClient: NetworkClient {
    
    // MARK: - Properties
    
    /// Sesión utilizada para realizar todas las peticiones HTTP.
    /// Por defecto utilizaremos la sesión compartida de URLSession.
    private let session: URLSession
    
    /// Configuración general de la API (URL base, etc.).
    private let configuration: APIConfiguration
    
    /// Indica si las peticiones y respuestas deben mostrarse en la consola durante el desarrollo.
    private let isLoggingEnabled: Bool
    
    // MARK: - Initializer
    
    /// Inicializa el cliente de red.
    
    /// - Parameters:
    ///   - session: Sesión que realizará las peticiones HTTP. Por defecto usamos la compartida.
    ///   - configuration: Configuración general de la API.
    init(
        session: URLSession = .shared,
        configuration: APIConfiguration = .default,
        isLoggingEnabled: Bool = true
    ) {
        /// Guardamos la sesión encargada de realizar las peticiones HTTP.
        self.session = session
        
        /// Guardamos la configuración general de la API.
        self.configuration = configuration
        
        /// Guardamos si queremos mostrar información de las peticiones en la consola.
        self.isLoggingEnabled = isLoggingEnabled
    }
    
    // MARK: - NetworkClient
    
    /// Envía una petición y convierte el JSON recibido en el modelo solicitado.
    @discardableResult
    func send<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as type: T.Type
    ) async throws -> T {
        
        /// Ejecutamos la petición y obtenemos los datos crudos del servidor.
        let (data, _) = try await perform(endpoint)
        
        do {
            /// Convertimos el JSON recibido en el tipo solicitado.
            return try Self.makeDecoder().decode(
                T.self,
                from: data
            )
        } catch {
            /// Convertimos el fallo de decodificación en un error propio de la app.
            throw APIError.decoding(String(describing: error))
        }
    }
    
    /// Envía una petición que no necesita decodificar ninguna respuesta.
    func send(_ endpoint: Endpoint) async throws {
        /// Ejecutamos la petición y descartamos los datos recibidos.
        _ = try await perform(endpoint)
    }
    
    // MARK: - Trabajo común
    
    /// Construye, envía y valida una petición HTTP.
    /// Devuelve los datos crudos y la respuesta HTTP para que otros métodos
    /// puedan decidir si deben decodificarlos.
    private func perform(
        _ endpoint: Endpoint
    ) async throws -> (Data, HTTPURLResponse) {
        
        /// Convierte el endpoint en una URLRequest lista para enviarse.
        let request = try endpoint.makeRequest(
            with: configuration,
            token: nil
        )
        
        let data: Data
        let response: URLResponse
        
        do {
            
            /// Enviamos la petición y esperamos la respuesta del servidor.
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .notConnectedToInternet {
            
            /// Transformamos el error de falta de conexión en un error propio.
            throw APIError.offline
        } catch {
            
            /// Convertimos cualquier otro fallo de transporte en APIError.
            throw APIError.transport(error.localizedDescription)
        }
        
        /// Comprueba que la respuesta recibida sea una respuesta HTTP válida.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        /// Mostramos la petición y la respuesta en consola durante el desarrollo.
        debug(request: request, response: (data, response))
        
        /// Validamos que el servidor haya respondido correctamente.
        try validate(httpResponse, data: data)
        
        /// Devuelve los datos y la respuesta HTTP para validarlos y decodificarlos.
        return (data, httpResponse)
    }
    
    /// Valida el código de estado HTTP devuelto por el servidor.
    private func validate(
        _ response: HTTPURLResponse,
        data: Data
    ) throws {
        
        switch response.statusCode {
            
            /// Cualquier código entre 200 y 299 representa una respuesta correcta.
        case 200..<300:
            return
            
            /// Un código 401 indica que la sesión no es válida o ha caducado.
        case 401:
            throw APIError.unauthorized
            
            /// Cualquier otro código se trata como un error inesperado.
        default:
            let message = Self.extractServerMessage(from: data)
            
            throw APIError.unexpectedStatus(
                code: response.statusCode,
                message: message
            )
        }
    }
    
    /// Intenta extraer el mensaje de error enviado por el servidor.
    private static func extractServerMessage(
        from data: Data
    ) -> String? {
        
        /// Modelo interno que representa el formato de error del servidor.
        struct ServerError: Decodable {
            let reason: String?
        }
        
        /// Intentamos decodificar el mensaje sin provocar un nuevo error.
        return try? JSONDecoder()
            .decode(ServerError.self, from: data)
            .reason
    }
    
    /// Crea el decodificador utilizado por todas las respuestas de la API.
    private static func makeDecoder() -> JSONDecoder {
        
        /// Creamos una nueva instancia de JSONDecoder.
        let decoder = JSONDecoder()
        
        /// Indicamos que las fechas recibidas siguen el formato ISO 8601.
        decoder.dateDecodingStrategy = .iso8601
        
        /// Devolvemos el decodificador configurado.
        return decoder
    }
    
    // MARK: - Debug
    private func debug(
        request: URLRequest,
        response: (Data, URLResponse)
    ) {
#if DEBUG
        
        guard isLoggingEnabled else { return }
        
        var logMessage = "###########################################################################"
        
        if let httpResponse = response.1 as? HTTPURLResponse {
            logMessage.append("\n\nSTATUS CODE:\n\(httpResponse.statusCode)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            logMessage.append("\n\nHEADERS:\n\(headers)")
        }
        
        /// Añadimos el método HTTP utilizado.
        if let method = request.httpMethod {
            logMessage.append("\n\nMETHOD:\n\(method)")
        }
        
        /// Añadimos la URL final de la petición.
        if let url = response.1.url?.absoluteString {
            logMessage.append("\n\nURL:\n\(url)")
        }
        
        /// Añadimos el body enviado, si existe.
        if let bodyData = request.httpBody,
           let body = String(data: bodyData, encoding: .utf8) {
            
            logMessage.append("\n\nBODY DATA:\n\(body)")
        }
        
        /// Añadimos el cuerpo de la respuesta convertido a texto.
        if let responseBody = String(
            data: response.0,
            encoding: .utf8
        ) {
            logMessage.append(
                "\n\nRESPONSE DATA:\n\n\(responseBody)"
            )
        }
        
        logMessage.append(
            "###################"
        )
        
        /// Mostramos toda la información en la consola de Xcode.
        print(logMessage)
        
#endif
        
    }
    
    
    
}

/*
 ──────────────────────────────────────────────
 
 RESUMEN DEL ARCHIVO
 
 Responsabilidad:
 Construir peticiones HTTP.
 
 Lo utiliza:
 - MangaRepository
 
 No debería utilizarlo:
 - Views
 - ViewModels
 
 Pregunta típica del profesor:
 ¿Por qué existe Endpoint en lugar de crear URLRequest directamente?
 
 Respuesta:
 Porque desacopla la definición de una petición HTTP de su ejecución,
 haciendo la arquitectura más reutilizable y fácil de mantener.
 
 ──────────────────────────────────────────────
 */
