//
//  MangaEndpoints.swift
//  MangaHub
//

import Foundation

// Agrupa todos los endpoints relacionados con los mangas.
nonisolated enum MangaEndpoints {
    
    // MARK: - List
    
    /// Devuelve un listado paginado de mangas.
    static func list(
        page: Int = 1,
        per: Int = 10
    ) -> Endpoint {
        
        // Creamos un endpoint GET para obtener los mangas.
        Endpoint(
            path: "/list/mangas",
            queryItems: [
                
                // Indicamos qué página queremos solicitar.
                URLQueryItem(
                    name: "page",
                    value: String(page)
                ),
                
                // Indicamos cuántos mangas queremos recibir por página.
                URLQueryItem(
                    name: "per",
                    value: String(per)
                )
            ]
        )
        
    }
    
    // MARK: - Search
    static func search(
        criteria: CustomSearch,
        page: Int,
        per: Int
    ) throws -> Endpoint {
        
        let body = try Endpoint.jsonBody(
            criteria
        )
        
        return Endpoint(
            
            path: "/search/manga",
            method: .post,
            queryItems: [
                URLQueryItem(
                    name: "page",
                    value: String(page)
                ),
                URLQueryItem(
                    name: "per",
                    value: String(per)
                )
            ],
            body: body
        )
        
    }
    
    // MARK: - Detail
    
    /// Devuelve un manga concreto a partir de su identificador.
    static func detail(
        id: Int
    ) -> Endpoint {
        
        Endpoint(path: "/search/manga/\(id)")
    }
}
