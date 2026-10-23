//
//  MangaResponse.swift
//  MangaHub
//

import Foundation

nonisolated struct MangaResponse: Codable, Sendable {
    
    // Mangas incluidos en la página solicitada.
    let items: [Manga]
    
    // Info de paginación.
    let metadata: Metadata
}
