//
//  CollectionRepositoryError.swift
//  MangaHub
//

import Foundation

/// Errores relacionados con la colección local.
enum CollectionRepositoryError: LocalizedError {
    
    /// El manga seleccionado ya estaba guardado.
    case mangaAlreadyExists
    
    /// El manga seleccionado no se encuentra en la colección.
    case mangaNotFound
    
    var errorDescription: String? {
        
        switch self {
            
        case .mangaAlreadyExists:
            return "Este manga ya pertenece a tu colección."
            
        case .mangaNotFound:
            return "No se ha encontrado el manga en tu colección."
            
        }
    }
}
