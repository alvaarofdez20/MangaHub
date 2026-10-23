//
//  CollectedMangaDetailScreen.swift
//  MangaHub
//

import SwiftUI

/// Recupera el manga completo desde la API antes de mostrar su pantalla de detalle.
struct CollectedMangaDetailScreen: View {
    
    // MARK: - Environment
    
    /// Dependencias globales de la aplicación.
    @Environment(AppEnvironment.self) private var environment
    
    // MARK: - Properties
    
    /// Identificador del manga guardado.
    let mangaId: Int
    
    // MARK: - State
    
    /// Manga completo recuperado desde la API.
    @State private var manga: Manga?
    
    /// Indica si se está realizando la petición.
    @State private var isLoading = true
    
    /// Mensaje mostrado cuando la carga falla.
    @State private var errorMessage: String?
    
    // MARK: - Body
    
    var body: some View {
        
        Group {
            
            if let manga {
                
                MangaDetailScreen(
                    manga: manga
                )
            } else if isLoading {
                
                ProgressView(
                    "Cargando manga..."
                )
            } else {
                
                ContentUnavailableView {
                    Label(
                        "No se pudo cargar el manga",
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(
                        errorMessage ?? "Se produjo un error desconocido"
                    )
                } actions: {
                    Button(
                        "Intentar de nuevo"
                    ) {
                        Task {
                            await loadManga()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .task {
            await loadManga()
        }
    }
}

// MARK: - Private methods

private extension CollectedMangaDetailScreen {
    
    /// Recupera el manga completo usando el identificador almacenado localmente.
    func loadManga() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            
            manga = try await environment.mangaRepository.fetchManga(
                id: mangaId
            )
        } catch {
            
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

