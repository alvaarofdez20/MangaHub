//
//  MangaCardView.swift
//  MangaHub
//

import SwiftUI

struct MangaCardView: View {
    
    let manga: Manga
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            
            ZStack(alignment: .bottomTrailing) {
                
                // Imagen de portada (de momento un rectángulo gris).
                AsyncImage(
                    url: URL(string: manga.mainPicture ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(.gray.opacity(0.2))
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(0.72, contentMode: .fit)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppCornerRadius.large,
                        style: .continuous
                    )
                )
                
                ScoreView(score: manga.score)
                    .padding(.horizontal, AppSpacing.small)
                    .padding(.vertical, AppSpacing.extraSmall)
                    .background(.black.opacity(0.75))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .padding(AppSpacing.small)
                
            }
                
                // Título del manga.
                Text(manga.title)
                .font(AppTypography.cardTitle)
                    .lineLimit(2)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 44,
                        alignment: .topLeading
                    )
                
                // Estado de publicación.
                Text(genreText)
                .font(AppTypography.secondary)
                .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
                
        }
        .padding(AppSpacing.small)
        .background(
            Color.appCardBackground,
            in: RoundedRectangle(
                cornerRadius: AppCornerRadius.large,
                style: .continuous
            )
        )
    }
    
    private var genreText: String {
        manga.genres
            .prefix(2)
            .map(\.genre)
            .joined(separator: " · ")
    }
    
}

#Preview {
    MangaCardView(
        manga: Manga.preview
    )
    .padding()
    .background(Color.appBackground)
}
