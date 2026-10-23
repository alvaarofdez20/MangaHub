//
//  HomeState.swift
//  MangaHub
//

import Foundation

/// Respresenta los posibles estados de la pantalla `Home`
enum HomeState {
    
    /// Cargando estado inicial
    case loading
    
    /// Muestra los mangas cargados
    case loaded([Manga])
    
    /// La API no devolvió mangas
    case apiEmpty
    
    /// Error al consultar la API
    case error(String)
}
