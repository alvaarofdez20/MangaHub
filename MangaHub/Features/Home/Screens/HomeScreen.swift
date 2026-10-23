//
//  HomeScreen.swift
//  MangaHub
//

import SwiftUI

struct HomeScreen: View {
    
    // MARK: - Environment
    @Environment(AppEnvironment.self) private var environment
    @Environment(AppRouter.self) private var router
    
    // MARK: - State
    @State private var viewModel: HomeViewModel?
    
    /// Indica si la carga inicial ya ha terminado.
    @State private var hasCompletedInitialLoad = false
    @State private var searchText = ""
    @State private var selectedGenre: MangaGenreFilter = .all
    
    private var searchTaskID: String {
        "\(hasCompletedInitialLoad)-\(searchText)-\(selectedGenre.rawValue)"
    }
    
    // MARK: - Body
    
    var body: some View {
        
        Group {
            
            if let viewModel {
                
                if !hasCompletedInitialLoad {
                    initialLoadingView
                } else {
                    content(viewModel)
                }
            } else  {
                initialLoadingView
            }
        }
        .task {
            
            guard viewModel == nil else { return }
            
            let viewModel = HomeViewModel(
                repository: environment.mangaRepository
            )
            
            self.viewModel = viewModel
            
            await viewModel.load()
            
            hasCompletedInitialLoad = true
        }
        .task(
            id: searchTaskID
        ) {
            
            /// No realizamos búsquedas hasta que la carga inicial haya terminado.
            guard hasCompletedInitialLoad else { return }
            
            do {
                
                try await Task.sleep(
                    for: .milliseconds(400)
                )
                
            } catch {
                
                return
                
            }
            
            guard let viewModel else { return }
            
            await viewModel.searchMangas(
                title: searchText,
                genre: selectedGenre
            )
        }
    }
    
    // MARK: - Initial Loading
    
    private var initialLoadingView: some View {
        
        ProgressView("Cargando mangas...")
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background(
                Color.appBackground
            )
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private func content(
        _ viewModel: HomeViewModel
    ) -> some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                /// Cabecera y buscador
                HomeHeaderView(
                    searchText: $searchText
                )
                
                /// Los filtros tambien permanecen visibles
                genreFilters
                    .padding(
                        .top,
                        AppSpacing.medium
                    )
                
                /// Mostramos el estado
                stateContent(viewModel)
                
            }
        }
        .frame(maxWidth: 1180)
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
    }
    
    /// Representa el estado actual de la pantalla principal
    @ViewBuilder
    private func stateContent(
        _ viewModel: HomeViewModel
    ) -> some View {
        
        switch viewModel.state {
            
        case .loading:
            
            ProgressView(
                "Cargando mangas..."
            )
            .frame(
                maxWidth: .infinity
            )
            .padding(
                .vertical,
                AppSpacing.extraLarge
            )
            
        case .loaded(let mangas):
            
            mangaGrid(mangas)
            
        case .apiEmpty:
            
            apiEmptyState
            
        case .error(let message):
            
            errorState(
                message: message,
                viewModel: viewModel
            )
        }
    }
    
    /// Muestra los mangas obtenidos desde la API
    private func mangaGrid(
        _ mangas: [Manga]
    ) -> some View {
        
        /// Listado de mangas.
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(
                        minimum: 170,
                        maximum: 220
                    ),
                    spacing: AppSpacing.medium
                )
            ],
            spacing: AppSpacing.sectionSpacing
        ) {
            
            ForEach(mangas) { manga in
                
                Button {
                    
                    router.openDetailFromHome(
                        manga
                    )
                } label: {
                    
                    MangaCardView(
                        manga: manga
                    )
                    .frame(maxWidth: 220)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: 1100)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppSpacing.extraLarge)
        .padding(.top, AppSpacing.large)
        .padding(.bottom, AppSpacing.large)
        
    }
    
    // MARK: - Subvistas
    
    private var genreFilters: some View {
        
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            
            HStack(
                spacing: AppSpacing.small
            ) {
                
                ForEach(
                    MangaGenreFilter.allCases
                ) { genre in
                    
                    Button {
                        selectedGenre = genre
                    } label: {
                        
                        Text(genre.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(
                                selectedGenre == genre
                                ? Color.white
                                : Color.primary
                            )
                            .padding(
                                .horizontal,
                                AppSpacing.medium
                            )
                            .padding(
                                .vertical,
                                AppSpacing.small
                            )
                            .background{
                                
                                Capsule()
                                    .fill(
                                        selectedGenre == genre
                                        ? Color.orange
                                        : Color.secondary.opacity(0.12)
                                    )
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(
                .horizontal,
                AppSpacing.extraLarge
            )
        }
    }
    
    private var apiEmptyState: some View {
        
        /// Se muestra una vista cuando no hay resultados de los filtros
        ContentUnavailableView{
            
            Label(
                "No se encontraron mangas",
                systemImage: "magnifyingglass"
            )
            
        } description: {
            
            Text("Prueba con otro título o cambia de género.")
            
        } actions: {
            
            Button(
                "Limpiar búsqueda"
            ) {

                /// Eliminamos el texto introducido por el usuario.
                searchText = ""

                /// Volvemos a mostrar todos los géneros.
                selectedGenre = .all
                
            }
            .buttonStyle(.bordered)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(
            .horizontal,
            AppSpacing.large
        )
        .padding(
            .vertical,
            AppSpacing.extraLarge
        )
    }
    
    private func errorState(
        message: String,
        viewModel: HomeViewModel
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
                    
                    let normalizedSearchText = searchText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                    
                    if !normalizedSearchText.isEmpty || selectedGenre != .all {
                        
                        await viewModel.searchMangas(
                            title: searchText,
                            genre: selectedGenre
                        )
                    } else {
                        await viewModel.load()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, AppSpacing.extraLarge)
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
    .environment(AppEnvironment.preview())
    .environment(AppRouter(stage: .main))
}
