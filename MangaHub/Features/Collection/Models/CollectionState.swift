//
//  CollectionState.swift
//  MangaHub
//

import Foundation

/// Representa posibles estados de la pantalla colección.
enum CollectionState {
    
    /// La colección se está cargando.
    case loading
    
    /// La colección contiene mangas.
    case loaded
    
    /// El usuario todavia no ha añadido ningún manga.
    case empty
    
    /// Se produjo un error al cargar la colección.
    case error(String)
}
