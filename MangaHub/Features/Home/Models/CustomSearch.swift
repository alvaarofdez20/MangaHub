//
//  CustomSearch.swift
//  MangaHub
//

import Foundation

nonisolated struct CustomSearch: Codable, Sendable {
    
    // MARK: - Search
    
    /// Texto a buscar por título
    let searchTitle: String?
    
    /// Nombre del autor
    let searchAuthorFirstName: String?
    
    /// Apellidos del autor
    let searchAuthorLastName: String?
    
    /// Generos seleccionados
    let searchGenres: [String]?
    
    /// Temáticas seleccionadas
    let searchThemes: [String]?
    
    /// Demografías seleccionadas
    let searchDemographics: [String]?
    
    /// Determina el comportamiento de la búsqueda textual.

    /// false: el título o autor debe comenzar por el texto.
    /// true: el título o autor debe contener el texto.
    let searchContains: Bool
}

extension CustomSearch {
    
    /// Búsqueda orientada al título y géneros
    init(
        title: String? = nil,
        genres: [String]? = nil,
        themes: [String]? = nil,
        demographics: [String]? = nil,
        contains: Bool = true
    ) {
        self.init(
            searchTitle: title,
            searchAuthorFirstName: nil,
            searchAuthorLastName: nil,
            searchGenres: genres,
            searchThemes: themes,
            searchDemographics: demographics,
            searchContains: contains
        )
    }
}
