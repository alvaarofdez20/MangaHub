//
//  HomeViewModel.swift
//  MangaHub
//

import SwiftUI
import Observation

@MainActor
@Observable
final class HomeViewModel {
    
    // MARK: - Dependeces
    
    /// Repositorio para obtener los mangas.
    private let repository: any MangaRepository
    
    // MARK: - State
    
    /// Lista de mangas mostrada en la pantalla principal.
    private(set) var mangas: [Manga] = []
    
    /// Mangas recibidos en el listado inicial.
    private var initialMangas: [Manga] = []
    
    /// Estado que debe representar la pantalla.
    private(set) var state: HomeState = .loading
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let firstPage = 1
        static let itemsPerPage = 10
        static let searchItemsPerPage = 20
        
    }
    
    // MARK: - Initializer
    
    init(repository: any MangaRepository) {
        self.repository = repository
    }
    
    // MARK: - Load
    
    /// Solicita la primera página de mangas
    func load() async {
        
        state = .loading
        
        do {
            
            let response = try await repository.fetchMangas(
                page: Constants.firstPage,
                per: Constants.itemsPerPage
            )
            
            initialMangas = response.items
            mangas = response.items
            
            updateState()
        } catch is CancellationError {
            return
        } catch {
            
            state = .error(
                error.localizedDescription
            )
        }
    }
    
    // MARK: - Search
    
    /// Busca mangas por título.
    func searchMangas(
        title: String,
        genre: MangaGenreFilter
    ) async {
        
        /// Quitamos saltos de línea y espacios.
        let normalizedTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        /// Convertimos el genero visual en el valor
        let selectedGenres = genre.apiValue.map {
            [$0]
        }
        
        guard !normalizedTitle.isEmpty || selectedGenres != nil else {
            
            mangas = initialMangas
            updateState()
            return
        }
        
        state = .loading
        
        /// Creamos el JSON solicitado por la API
        let criteria = CustomSearch(
            searchTitle: normalizedTitle.isEmpty
                ? nil
                : normalizedTitle,
            searchAuthorFirstName: nil,
            searchAuthorLastName: nil,
            searchGenres: selectedGenres,
            searchThemes: nil,
            searchDemographics: nil,
            searchContains: true
        )
        
        do {
            
            let response = try await repository.searchMangas(
                criteria: criteria,
                page: Constants.firstPage,
                per: Constants.searchItemsPerPage
            )
            
            /// Sustituimos el listado actual por los resultados obtenidos.
            mangas = response.items
            updateState()
            
        } catch is CancellationError {
            
            return
            
        } catch {
            
            state = .error(
                error.localizedDescription
            )
        }
    }
    
    // MARK: - State
    
    /// Actualiza el estado usando los mangas y los filtros.
    func updateState() {
        
        /// Si la API no devuelve mangas, mostramos el estado vacio
        if mangas.isEmpty {
            state = .apiEmpty
        } else {
            state = .loaded(mangas)
        }
    }
}
