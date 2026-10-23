//
//  CollectionViewModel.swift
//  MangaHub
//

import Foundation
import Observation

// MARK: - Collection Sort Option

/// Opciones disponibles para ordenar los mangas guardados en la colección.
enum CollectionSortOption: String, CaseIterable, Identifiable {
    
    case recent
    case title
    case rating
    case readingProgress
    
    var id: Self {
        self
    }
    
    /// Texto mostrado al usuario.
    var title: String {
        
        switch self {
            
        case .recent:
            return "Más recientes"
            
        case .title:
            return "Título"
            
        case .rating:
            return "Mejor valorados"
            
        case .readingProgress:
            return "Más leídos"
        }
    }
    
    /// Símbolo utilizado en el menú.
    var symbol: String {
        
        switch self {
            
        case .recent:
            return "clock"
            
        case .title:
            return "textformat"
            
        case .rating:
            return "star"
            
        case .readingProgress:
            return "book.pages"
        }
    }
}

@Observable
@MainActor
final class CollectionViewModel {
    
    // MARK: - Dependences
    
    /// Repositorio encargado de gestionar la colección.
    private let repository: any CollectionRepository
    
    // MARK: - Properties
    
    /// Texto introducido en el buscador de la colección.
    var searchText = ""
    
    /// Orden seleccionado por el usuario.
    var selectedSortOption: CollectionSortOption = .recent
    
    // MARK: - State
    
    /// Estado de la pantalla.
    private(set) var state: CollectionState = .loading
    
    // MARK: - Initializer
    
    init(
        repository: any CollectionRepository
    ) {
        self.repository = repository
    }
    
    // MARK: - Actions
    
    /// Carga todos los datos de la colección.
    func load() {
        
        state = .loading
    
        do {
            
            let mangas = try repository.fetchAll()
            
            allMangas = mangas
            
            if mangas.isEmpty {
                
                state = .empty
                
            } else {
                
                state = .loaded
                
            }
            
        } catch {
            
            state = .error(error.localizedDescription)
        }
    }
    
    /// Elimina un manga de la colección y vuelve a cargar el estado de la pantalla.
    func remove(
        mangaId: Int
    ) {
        
        do {
            
            try repository.remove(mangaId: mangaId)
            
            load()
        } catch {
            
            state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Search
    
    /// Copia completa de los mangas cargados.
    private var allMangas: [CollectedManga] = []
    
    /// Mangas que coinciden con la búsqueda actual.
    var filteredMangas: [CollectedManga] {
        
        let normalizedSearchText = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        let searchedMangas: [CollectedManga]
        
        if normalizedSearchText.isEmpty {
            searchedMangas = allMangas
        } else {
            
            searchedMangas = allMangas.filter { manga in
                
                manga.title.localizedCaseInsensitiveContains(normalizedSearchText)
            }
        }
        
        return sort(searchedMangas)
    }
    
    // MARK: - Private Helpers

    /// Ordena los mangas según la opción seleccionada.
    private func sort(
        _ mangas: [CollectedManga]
    ) -> [CollectedManga] {
        
        switch selectedSortOption {
            
        case .recent:
            return mangas.sorted { first, second in
                first.addedAt > second.addedAt
            }
            
        case .title:
            return mangas.sorted { first, second in
                
                first.title.localizedCaseInsensitiveCompare(
                    second.title
                ) == .orderedAscending
            }
            
        case .rating:
            return mangas.sorted { first, second in
                
                if first.personalRating == second.personalRating {
                    
                    return first.title.localizedCaseInsensitiveCompare(
                        second.title
                    ) == .orderedAscending
                }
                
                return first.personalRating > second.personalRating
            }
            
        case .readingProgress:
            return mangas.sorted { first, second in
                
                if first.readingVolume == second.readingVolume {
                    
                    return first.title.localizedStandardCompare(
                        second.title
                    ) == .orderedAscending
                }
                
                return first.readingVolume > second.readingVolume
            }
        }
    }
}
