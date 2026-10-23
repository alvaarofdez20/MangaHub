//
//  Author.swift
//  MangaHub
//

import Foundation

nonisolated struct Author: Codable, Hashable {
    
    let id: String
    let lastName: String
    let firstName: String
    let role: String
    
}
