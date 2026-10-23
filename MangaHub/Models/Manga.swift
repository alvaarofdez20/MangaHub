//
//  Manga.swift
//  MangaHub
//

import Foundation

nonisolated struct Manga: Codable, Identifiable, Hashable {
    
    // Identificador único del manga.
    let id: Int
    
    // Títulos en los distintos idiomas.
    let title: String
    
    let titleJapanese: String?
    let titleEnglish: String?
    
    // Fechas de publicación.
    let endDate: String?
    let startDate: String?
    
    // Información general del manga.
    let chapters: Int?
    let url: String?
    let sypnosis: String?
    let mainPicture: String?
    let score: Double
    let status: String
    let volumes: Int?
    let background: String?
    
    // Relaciones con otros modelos.
    let authors: [Author]
    let demographics: [Demographic]
    let genres: [Genre]
    let themes: [Theme]
    
}
