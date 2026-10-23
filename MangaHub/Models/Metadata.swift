//
//  Metadata.swift
//  MangaHub
//

import Foundation

// Contiene la información de paginación incluida en los listados de la API.
nonisolated struct Metadata: Codable, Sendable {
    
    // Número total de mangas disponibles para la consulta.
    let total: Int
    
    // Página actual devuelta por el servidor.
    let page: Int
    
    // Número de elementos solicitados por página.
    let per: Int
    
}
