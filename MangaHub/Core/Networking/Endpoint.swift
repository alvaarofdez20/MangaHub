//
//  Endpoint.swift
//  MangaHub
//

import Foundation

/// Representa una petición HTTP de la aplicación.

/// Un Endpoint no realiza la petición.
/// Únicamente describe cómo debe hacerse:
/// - Ruta (path)
/// - Método HTTP
/// - Parámetros
/// - Body
/// - Cabeceras
/// - Si requiere autenticación

/// Será utilizado por `NetworkClient` para construir un `URLRequest`.

nonisolated struct Endpoint: Sendable {
    
    // MARK: - Properties

    /// Ruta relativa del endpoint
    let path: String
    
    /// Método HTTP
    let method: HTTPMethod
    
    /// Parámetros añadidos a la URL
    let queryItems: [URLQueryItem]
    
    /// Cuerpo JSON codificado
    let body: Data?
    
    let headers: [String: String]
    let requiresAuth: Bool
    
    // MARK: - Initializer
    
    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil,
        headers: [String: String] = [:],
        requiresAuth: Bool = false
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.headers = headers
        self.requiresAuth = requiresAuth
    }
    
    /// Convierte la información del Endpoint en un URLRequest listo para ser enviado mediante URLSession.
    func makeRequest(
        with configuration: APIConfiguration,
        token: String?
    ) throws -> URLRequest {
        
        /// Construimos la URL completa uniendo la URL base con el path del endpoint.
        let fullURL = configuration.baseURL.appending(path: path)
        
        /// Creamos los componentes de la URL para poder añadir parámetros de consulta.
        guard var components = URLComponents(
            url: fullURL,
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if requiresAuth, let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    /// Convierte cualquier modelo que implemente Encodable en datos JSON.
    /// Lo utilizaremos en los POST (login, registro, añadir a favoritos, etc.).
    static func jsonBody(_ value: some Encodable) throws -> Data {
        // JSONEncoder transforma un modelo Swift en un objeto Data con formato JSON.
        try JSONEncoder().encode(value)
    }
    
}
