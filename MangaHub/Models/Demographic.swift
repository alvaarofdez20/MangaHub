//
//  Demographic.swift
//  MangaHub
//

import Foundation

// Representa el público objetivo de un manga.

nonisolated struct Demographic: Codable, Hashable {
    
    let id: String
    let demographic: String
    
}
