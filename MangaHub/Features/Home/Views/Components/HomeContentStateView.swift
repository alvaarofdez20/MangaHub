//
//  HomeContentStateView.swift
//  MangaHub
//

import SwiftUI

struct HomeContentStateView<LoadedContent: View>: View {
    
    // MARK: Properties
    
    /// Estado de la pantalla actual
    let state: HomeState
    
    /// Acción utilizada para limpiar la búsqueda
    let onClearSearch: () -> Void
    
    /// Acción asíncrona para repetir una petición
    let onRetry: () async -> Void
    
    /// Contenido que debe mostrarse cuando existan mangas
    private let loadedContent: ([Manga]) -> LoadedContent
    
    // MARK: - Initializer
    
    init(
        state: HomeState,
        onClearSearch: @escaping () -> Void,
        onRetry: @escaping () async -> Void,
        @ViewBuilder loadedContent: @escaping ([Manga]) -> LoadedContent
    ) {
        self.state = state
        self.onClearSearch = onClearSearch
        self.onRetry = onRetry
        self.loadedContent = loadedContent
    }
    
    // MARK: - Body
    
    var body: some View {
        
        switch state {
            
        case .loading:
            loadingState
            
        case .loaded(let mangas):
            loadedContent(mangas)
            
        case .apiEmpty:
            apiEmptyState
            
        case .error(let message):
            errorState(
                message: message
            )
            
        }
        
    }
}

private extension HomeContentStateView {
    
    var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
            
            Text("Cargando mangas...")
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
    var apiEmptyState: some View {
        ContentUnavailableView {
            Label(
                "No se encontraron mangas",
                systemImage: "book.closed"
            )
        } description: {
            
            Text("Prueba con otro título o cambia el género seleccionado.")
        } actions: {
            
            Button(
                "Limpiar búsqueda",
                action: onClearSearch
            )
            .buttonStyle(.borderedProminent)
        }
    }
    
    func errorState(
            message: String
        ) -> some View {

            ContentUnavailableView {

                Label(
                    "No se pudieron cargar los mangas",
                    systemImage: "exclamationmark.triangle"
                )

            } description: {

                Text(message)

            } actions: {

                Button(
                    "Intentar de nuevo"
                ) {

                    Task {
                        await onRetry()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    
}
