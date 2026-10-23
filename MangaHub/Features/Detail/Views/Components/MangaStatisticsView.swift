//
//  MangaStatisticsView.swift
//  MangaHub
//

import SwiftUI

struct MangaStatisticsView: View {
    
    // MARK: - Properties
    
    /// Manga del que mostramos los datos
    let manga: Manga
    
    // MARK: - Body
    
    var body: some View {
        
        HStack(
            spacing: AppSpacing.medium
        ) {
            
            statisticItem(
                value: volumesText,
                title: "Tomos",
                systemImage: "books.vertical"
            )
            
            statisticItem(
                value: scoreText,
                title: "Rating",
                systemImage: "star.fill"
            )
            
            statisticItem(
                value: formattedStatus,
                title: "Estado",
                systemImage: "clock"
            )
        }
    }
    
    // MARK: - Statistic Item
    
    private func statisticItem(
        value: String,
        title: String,
        systemImage: String
    ) -> some View {
        
        VStack(
            spacing: AppSpacing.small
        ) {
            
            Image(
                systemName: systemImage
            )
            .font(.title3)
            .foregroundStyle(Color.orange)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, AppSpacing.large)
        .padding(.horizontal, AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
            .fill(
                Color.secondary.opacity(0.08)
            )
        )
    }
    
    // MARK: - Helpers
    
    private var volumesText: String {
        
        guard let volumes = manga.volumes else { return "-" }
        
        return String(volumes)
    }
    
    private var scoreText: String {
        
        manga.score.formatted(
            .number.precision(
                .fractionLength(1)
            )
        )
    }
    
    private var formattedStatus: String {
        
        switch manga.status.lowercased() {
            
        case "currently_publishing":
            return "En curso"
            
        case "finished":
            return "Finalizado"
            
        default:
            return manga.status
                .replacingOccurrences(
                    of: "_",
                    with: " "
                )
                .capitalized
        }
    }
}

