//
//  MangaGenreFilter.swift
//  MangaHub
//

import Foundation

/// Representa los géneros disponibles como filtro
enum MangaGenreFilter: String, CaseIterable, Identifiable, Sendable {
    
    // MARK: - Cases
    
    case all
    case action
    case adventure
    case comedy
    case drama
    case fantasy
    case romance
    
    // MARK: - ID
    
    /// Permite utilizar el género directamente dentro de un ForEach
    var id: Self { self }
    
    // MARK: - API Value
    
    /// Valor exacto enviado a la API
    var apiValue: String? {
        
        switch self {
            
        case .all:
            return nil
            
        case .action:
            return "Action"
            
        case .adventure:
            return "Adventure"
            
        case .comedy:
            return "Comedy"
            
        case .drama:
            return "Drama"
            
        case .fantasy:
            return "Fantasy"
            
        case .romance:
            return "Romance"
            
        }
        
    }
    
    // MARK: - Display Name
    
    /// Texto mostrado al usuario
    var displayName: String {
        
        switch self {
            
        case .all:
            return "Todos"
            
        case .action:
            return "Acción"
            
        case .adventure:
            return "Aventura"
            
        case .comedy:
            return "Comedia"
            
        case .drama:
            return "Drama"
            
        case .fantasy:
            return "Fantasía"
            
        case .romance:
            return "Romance"
            
        }
        
    }
    
}
