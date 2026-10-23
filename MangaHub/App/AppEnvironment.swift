//
//  AppEnvironment.swift
//  MangaHub
//

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class AppEnvironment {
    
    // MARK: - Dependencies
    
    /// Repositorio encargado de obtener los mangas.
    let mangaRepository: any MangaRepository
    
    /// Repositorio encargado de gestionar la colección actual.
    let collectionRepository: any CollectionRepository
    
    // MARK: - Initializer
    
    init(
        mangaRepository: any MangaRepository,
        collectionRepository: any CollectionRepository
    ) {
        self.mangaRepository = mangaRepository
        self.collectionRepository = collectionRepository
    }
    
}

// MARK: - Live

extension AppEnvironment {
    
    /// Crea las dependencias reales utilizadas por la aplicación.
    static func live(
        modelContext: ModelContext
    ) -> AppEnvironment {
        
        /// Cliente encargado de realizar las peticiones HTTP.
        let network = URLSessionNetworkClient()
        
        /// Repositorio que obtiene los mangas desde la API.
        let mangaRepository = MangaRepositoryImpl(
            network: network
        )
        
        /// Repositorio que guarda la colección mediante SwiftData.
        let collectionRepository = SwiftDataCollectionRepository(
            modelContext: modelContext
        )
        
        return AppEnvironment(
            mangaRepository: mangaRepository,
            collectionRepository: collectionRepository
        )
    }
}

// MARK: - Preview

extension AppEnvironment {
    
    /// Crea dependencias temporales para previews.
    static func preview() -> AppEnvironment {
        
        let response = MangaResponse(
            items: [.preview],
            metadata: Metadata(
                total: 1,
                page: 1,
                per: 10
            )
        )
        
        let mangaRepository = MockMangaRepository(
            response: response
        )
        
        do {
            
            /// Configuración temporal
            let configuration = ModelConfiguration(
                isStoredInMemoryOnly: true
            )
            
            /// Contenedor temporal para CollectedManga
            let modelContainer = try ModelContainer(
                for: CollectedManga.self,
                configurations: configuration
            )
            
            let collectionRepository = SwiftDataCollectionRepository(
                modelContext: modelContainer.mainContext
            )
            
            return AppEnvironment(
                mangaRepository: mangaRepository,
                collectionRepository: collectionRepository
            )
        } catch {
            
            fatalError("No se pudo crear el contenedor de SwifData para previews: \(error)")
        }
    }
}
