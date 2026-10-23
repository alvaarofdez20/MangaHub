//
//  MangaHubApp.swift
//  MangaHub
//

import SwiftUI
import SwiftData

@main
struct MangaHubApp: App {
    
    // MARK: - Dependencies
    
    /// Contenedor principal de SwiftData.
    private let modelContainer: ModelContainer
    
    /// Dependencias globales de la aplicación.
    @State private var environment: AppEnvironment
    
    /// Controlador global de navegación.
    @State private var router: AppRouter
    
    // MARK: - Initializer
    
    init() {
        
        do {
            /// Contenedor persistente que almacena los mangas guardados en la coleeción.
            let container = try ModelContainer(
                for: CollectedManga.self
            )
            
            /// Guardamos el contenedor para inyectarlo en SwiftUI.
            modelContainer = container
            
            _environment = State(
                initialValue: AppEnvironment.live(
                    modelContext: modelContainer.mainContext
                )
            )
            
            _router = State(
                initialValue: AppRouter(
                    stage: .main
                )
            )
        } catch {
            
            fatalError("No se pudo crear el contenedor de SwiftData: \(error) ")
        }
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(environment)
                .environment(router)
                .modelContainer(modelContainer)
        }
    }
}
