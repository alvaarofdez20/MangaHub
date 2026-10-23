//
//  CollectionMangaRowView.swift
//  MangaHub
//

import SwiftUI

struct CollectionMangaRowView: View {
    
    // MARK: - Properties
    
    /// Manga guardado en tu colección local.
    let manga: CollectedManga
    
    // MARK: - Body
    
    var body: some View {
        
        HStack(
            alignment: .top,
            spacing: AppSpacing.medium
        ) {
            
            coverImage
            
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                
                volumesText
                
                if let totalVolumes = manga.totalVolumes, totalVolumes > 0 {
                    
                    readingProgressText
                    readingProgressBar
                }
                
                if manga.isCollectionComplete {
                    
                    Label(
                        "Colección completa",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.green)
                }
                
                if manga.personalRating > 0 {
                    ratingView
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(AppSpacing.medium)
        .background(Color.appCardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
        )
    }
}

// MARK: - Subviews

private extension CollectionMangaRowView {
    
    /// Muestra la portada almacenada del manga.
    @ViewBuilder
    var coverImage: some View {
        
        if let coverURL = manga.coverURL,
           let url = URL(string: coverURL) {
            
            AsyncImage(
                url: url
            ) { phase in
                
                switch phase {
                    
                case .empty:
                    
                    ProgressView()
                case .success(let image):
                    
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    
                    placeholderCover
                        .frame(
                            width: 95,
                            height: 140
                        )
                default:
                    
                    placeholderCover
                        .frame(
                            width: 95,
                            height: 140
                        )
                }
            }
            .frame(
                width: 95,
                height: 140
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppCornerRadius.medium
                )
            )
        } else {
            
            placeholderCover
                .frame(
                    width: 85,
                    height: 125
                )
        }
    }
    
    /// Portada utilizada cuando no existe una imagen válida.
    var placeholderCover: some View {
        
        RoundedRectangle(
            cornerRadius: AppCornerRadius.medium
        )
        .fill(
            Color.secondary.opacity(0.15)
        )
        .overlay {
            
            Image(systemName: "book.closed")
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
    
    /// Texto con el progreso de tomos adquiridos.
    var volumesText: some View {
        
        Group {
            
            if let totalVolumes = manga.totalVolumes {
                
                Text("\(manga.ownedVolumes) de \(totalVolumes) tomos")
            } else {
                
                Text("\(manga.ownedVolumes) tomos")
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    
    /// Muestra la valoración personal mediante estrellas.
    var ratingView: some View {
        
        HStack(spacing: 2) {
            
            ForEach(
                1...5,
                id: \.self
            ) { rating in
                
                Image(
                    systemName: rating <= manga.personalRating
                    ? "star.fill"
                    : "star"
                )
            }
        }
        .font(.caption)
        .foregroundStyle(.orange)
        .accessibilityLabel(
            "Valoración: \(manga.personalRating) de 5"
        )
    }
    
    /// Muestra el progreso actual de lectura.
    var readingProgressText: some View {
        
        Label(
            readingProgressDescription,
            systemImage: "bookmark"
        )
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    
    /// Construye el texto correspondiente al tomo actual de lectura.
    var readingProgressDescription: String {
        
        guard manga.readingVolume > 0 else {
            return "Sin empezar"
        }
        
        return "Leídos \(manga.readingVolume) de \(manga.ownedVolumes) tomos en posesión"
    }
    
    /// Muestra una barra de progreso de lectura del manga.
    @ViewBuilder
    var readingProgressBar: some View {
        
        if manga.ownedVolumes > 0 {
            
            ProgressView(
                value: Double(manga.readingVolume),
                total: Double(manga.ownedVolumes)
            )
            .accessibilityLabel(
                "Progreso de lectura"
            )
            .accessibilityValue(
                "\(manga.readingVolume) de \(manga.ownedVolumes) tomos en posesión."
            )
        }
    }
}

