//
//  CollectionView.swift
//  MangaHub
//

import SwiftUI

struct CollectionScreen: View {
    
    // MARK: - Environment
    
    /// Dependencias globales de la aplicación.
    @Environment(AppEnvironment.self) private var environment
    
    // MARK: - State
    
    /// ViewModel encargado de gestionar la colección.
    @State private var viewModel: CollectionViewModel?
    
    /// Manga pendiente de confirmar su eliminación.
    @State private var mangaPendingDeletion: CollectedManga?
    
    // MARK: - Body
    
    var body: some View {
        
        Group {
            
            if let viewModel {
                
                @Bindable var viewModel = viewModel
                
                collectionContent(viewModel)
                    .frame(maxWidth: .infinity)
                    .toolbar {
                        
                        ToolbarItem(
                            placement: .topBarTrailing
                        ) {
                            
                            Menu {
                                
                                Picker(
                                    "Ordenar por",
                                    selection: $viewModel.selectedSortOption
                                ) {
                                    
                                    ForEach(
                                        CollectionSortOption.allCases
                                    ) { option in
                                        
                                        Label(
                                            option.title,
                                            systemImage: option.symbol
                                        )
                                        .tag(option)
                                    }
                                }
                            } label: {
                                
                                Label(
                                    "Ordenar",
                                    systemImage: "arrow.up.arrow.down"
                                )
                            }
                        }
                    }
                
            } else {
                
                ProgressView()
            }
        }
        .task {
            
            guard viewModel == nil else { return }
            
            let viewModel = CollectionViewModel(
                repository: environment.collectionRepository
            )
            
            self.viewModel = viewModel
        }
        .onAppear{ viewModel?.load() }
        .alert(
            "Eliminar manga",
            isPresented: deletionConfirmationBinding
        ) {
            
            Button(
                "Cancelar",
                role: .cancel
            ) {
                mangaPendingDeletion = nil
            }
            
            Button(
                "Eliminar",
                role: .destructive
            ) {
                confirmDeletion()
            }
        } message: {
            
            if let mangaPendingDeletion {
                
                Text("¿Quieres eliminar \"\(mangaPendingDeletion.title)\" de tu colección?")
            }
        }
    }
}

// MARK: - Content

private extension CollectionScreen {
    
    ///Muestra el contenido correspondiente al estado actual de la colección.
    @ViewBuilder
    func content(
        _ viewModel: CollectionViewModel
    ) -> some View {
        
        switch viewModel.state {
            
        case .loading:
            
            ProgressView("Cargando colección...")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
            
        case .loaded:
            
            if viewModel.filteredMangas.isEmpty {
                
                searchEmptyState(
                    viewModel: viewModel
                )
            } else {
                
                collectionList(
                    mangas: viewModel.filteredMangas,
                    onRequestDelete: { manga in
                        requestDeletion(of: manga)
                    }
                )
            }
            
        case .empty:
            
            ContentUnavailableView(
                "Tu colección está vacía",
                systemImage: "books.vertical",
                description: Text(
                    "Añade mangas desde la pestaña Explorar."
                )
            )
            
        case .error(let message):
            
            ContentUnavailableView {
                
                Label(
                    "No se pudo cargar la colección",
                    systemImage: "exclamationmark.triangle"
                )
            } description: {
                
                Text(message)
            } actions: {
                
                Button(
                    "Intentar de nuevo"
                ) {
                    viewModel.load()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ViewBuilder
    func collectionContent(
        _ viewModel: CollectionViewModel
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            
            Text("Mi Colección")
                .font(AppTypography.screenTitle)
                .foregroundStyle(Color.appTextPrimary)
            
            HStack(spacing: AppSpacing.small) {
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField(
                    "Buscar en mi colección",
                    text: Binding(
                        get: {
                            viewModel.searchText
                        },
                        set: {
                            viewModel.searchText = $0
                        }
                    )
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                if !viewModel.searchText.isEmpty {
                    
                    Button {
                        
                        viewModel.searchText = ""
                    } label: {
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.medium)
            .frame(minHeight: 44)
            .background(
                Color.secondary.opacity(0.12),
                in: RoundedRectangle(
                    cornerRadius: AppCornerRadius.large
                )
            )
            
            content(viewModel)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .padding(.horizontal, AppSpacing.extraLarge)
        .padding(.top, AppSpacing.large)
        .background(Color.appBackground)
    }
    
    /// Controla la presentación del diálogo de eliminación.
    var deletionConfirmationBinding: Binding<Bool> {
        
        Binding(
            get: {
                mangaPendingDeletion != nil
            },
            set: { isPresented in
                
                if !isPresented {
                    mangaPendingDeletion = nil
                }
            }
        )
    }
    
    /// Guarda temporalmente el manga que el usuario desea eliminar.
    func requestDeletion(
        of manga: CollectedManga
    ) {
        mangaPendingDeletion = manga
    }
    
    /// Confirma y ejecuta la eliminación del manga seleccionado.
    func confirmDeletion() {
        
        guard let mangaPendingDeletion else {
            return
        }
        
        viewModel?.remove(
            mangaId: mangaPendingDeletion.mangaId
        )
        
        self.mangaPendingDeletion = nil
    }
    
    /// Se muestra cuando la colección contiene mangas,
    /// pero ninguno coincide con el texto buscado.
    func searchEmptyState(
        viewModel: CollectionViewModel
    ) -> some View {
        
        ContentUnavailableView {
            
            Label(
                "No se encontraron mangas",
                systemImage: "magnifyingglass"
            )
        } description: {
            
            Text("No hay ningún manga en tu colección que coincida con \(viewModel.searchText)")
        } actions: {
            
            Button("Limpiar búsqueda") {
                viewModel.searchText = ""
            }
            .buttonStyle(.bordered)
        }
    }
}

func collectionList(
    mangas: [CollectedManga],
    onRequestDelete: @escaping (CollectedManga) -> Void
) -> some View {
    
    List {
        
        collectionSumary(
            mangasCount: mangas.count
        )
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        
        ForEach(mangas) { manga in
            
            NavigationLink(
                value: CollectionRoute.detail(
                    mangaId: manga.mangaId
                )
            ) {
                CollectionMangaRowView(
                    manga: manga
                )
            }
            .buttonStyle(.plain)
            .listRowSeparator(.hidden)
            .listRowInsets(
                EdgeInsets(
                    top: AppSpacing.small,
                    leading: AppSpacing.medium,
                    bottom: AppSpacing.small,
                    trailing: AppSpacing.medium
                )
            )
            .listRowBackground(Color.clear)
            .swipeActions(
                edge: .trailing,
                allowsFullSwipe: true
            ) {
                
                Button(role: .destructive) {
                    
                    onRequestDelete(manga)
                } label: {
                    
                    Label("Eliminar", systemImage: "trash")
                }
            }
        }
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(Color.appBackground)
}

/// Muestra el número total de mangas guardados.
func collectionSumary(
    mangasCount: Int
) -> some View {
    
    HStack{
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.extraSmall
        ) {
            
            Text("Tu biblioteca")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(
                mangasCount == 1
                ? "1 manga guardado"
                : "\(mangasCount) mangas guardados"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        Spacer()
    }
}

#Preview {
    CollectionScreen()
}
