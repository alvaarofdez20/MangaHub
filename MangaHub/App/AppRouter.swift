//
//  AppRouter.swift
//  MangaHub
//

import Foundation
import Observation

// MARK: - App Stage
nonisolated enum AppStage: Equatable {
    case main
}

// MARK: - App Tab
nonisolated enum AppTab: String, CaseIterable, Identifiable {
    
    case home
    case collection
    
    var id: String { rawValue }
    var title: LocalizedStringResource {
        switch self {
        case .home:
            "Explorar"
        case .collection:
            "Colección"
        }
    }
    
    var symbol: String {
        switch self {
        case .home:
            "magnifyingglass"
        case .collection:
            "books.vertical"
        }
    }
}

// MARK: - Home Routes

nonisolated enum HomeRoute: Hashable {
    /// Abre el detalle desde la pantalla `Explorar`
    case detail(Manga)
}

// MARK: - Collection Routes

nonisolated enum CollectionRoute: Hashable {
    /// Abre el detalle de un manga guardado desde la pantalla `Colección`
    case detail(mangaId: Int)
}

@Observable
@MainActor
final class AppRouter {
    
    // MARK: - Navigation State
    
    /// Flujo principal
    var stage: AppStage
    
    /// Pestaña seleccionada
    var selectedTab: AppTab = .home
    
    /// Rutas apiladas
    var homePath: [HomeRoute] = []
    
    /// Rutas apiladas dentro de la pestaña `Colección`
    var collectionPath: [CollectionRoute] = []
    
    // MARK: - Initializer
    init (
        stage: AppStage
    ) {
        self.stage = stage
    }
    
    // MARK: - Navigation
    func openDetailFromHome(
        _ manga: Manga
    ) {
        selectedTab = .home
        
        let route = HomeRoute.detail(manga)
        
        if homePath.last != route {
            homePath.append(route)
        }
    }
}
