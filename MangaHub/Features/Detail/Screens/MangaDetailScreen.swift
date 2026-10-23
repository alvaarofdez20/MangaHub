//
//  DetailView.swift
//  MangaHub
//

import SwiftUI

struct MangaDetailScreen: View {
    
    // MARK: - Environment
    
    @Environment(AppEnvironment.self) private var environment
    
    // MARK: - Properties
    
    /// Manga seleccionado desde la pantalla principal
    private let manga: Manga
    
    // MARK: - State
    
    /// Manga seleccionado desde la pantalla principal.
    @State private var viewModel: MangaDetailViewModel?
    
    // MARK: - Initializer
    
    /// Crea la pantalla con el manga seleccionado
    ///
    /// El manga llega desde 'HomeRoute.detail'
    init(
        manga: Manga
    ) {
        self.manga = manga
    }
    
    // MARK: - Body
    
    var body: some View {
        
        Group {
            
            if let viewModel {
                
                content(viewModel)
                
            } else {
                
                ProgressView()
                
            }
            
        }
        .task {
            
            guard viewModel == nil else { return }
            
            self.viewModel = MangaDetailViewModel(
                manga: manga,
                collectionRepository: environment.collectionRepository
            )
            
        }
        
    }
    
    @ViewBuilder
    private func content(
        _ viewModel: MangaDetailViewModel
    ) -> some View {
        ScrollView {
            
            VStack(
                alignment: .leading,
                spacing: AppSpacing.sectionSpacing
            ) {
                
                MangaDetailHeaderView(
                    manga: viewModel.manga
                )
                
                MangaStatisticsView(
                    manga: viewModel.manga
                )
                
                MangaSynopsisView(
                    manga: viewModel.manga
                )
                
                if viewModel.isInCollection {
                    MangaCollectionManagementView(
                        isCollectionComplete: viewModel.isCollectionComplete,
                        ownedVolumes: viewModel.ownedVolumes,
                        totalVolumes: viewModel.manga.volumes,
                        personalRating: viewModel.personalRating,
                        onCollectionCompleteChanged: { isComplete in viewModel.setCollectionComplete(isComplete) },
                        onDecrementVolumes: { viewModel.decrementOwnedVolumes() },
                        onIncrementVolumes: { viewModel.incrementOwnedVolumes() },
                        onRatingSelected: { rating in viewModel.setPersonalRating(rating) }
                    )
                    
                    if let totalVolumes = viewModel.manga.volumes, totalVolumes > 0 {
                        ReadingProgressView(
                            viewModel: viewModel
                        )
                    }
                } else {
                    
                    CollectionButtonView {
                        viewModel.addToCollection()
                    }
                }
            }
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.medium)
            .padding(.bottom, AppSpacing.extraLarge)
        }
        .background(Color(.secondarySystemBackground))
    }
}

