//
//  MangaSynopsisView.swift
//  MangaHub
//

import SwiftUI

struct MangaSynopsisView: View {
    
    // MARK: - Properties
    
    /// Synopsis del manga
    let manga: Manga
    
    /// Controla si la synopsis se muestra completa o no
    @State private var isExpanded = false
    
    // MARK: - Constants
    
    private enum Constants {
        
        /// Número de líneas visibles antes de expandir
        static let collapsedLineLimit = 5
    }
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            
            sectionTitle
            
            synopsisCard
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
    
    // MARK: - Section Title
    
    private var sectionTitle: some View {
        
        Text("Synopsis")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
    }
    
    // MARK: - Synopsis Card
    
    private var synopsisCard: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            
            synopsisText
            
            if hasSynopsis {
                expandButton
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(AppSpacing.large)
        .background(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
            .fill(Color(.secondarySystemBackground))
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
            .stroke(
                Color.secondary.opacity(0.12),
                lineWidth: 1
            )
        }
        .shadow(
            color: .black.opacity(0.05),
            radius: 4,
            y: 2
        )
    }
    
    // MARK: - Synopsis Text
    
    @ViewBuilder
    private var synopsisText: some View {
        
        if let synopsis = manga.sypnosis,
            !synopsis.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty {
            
            Text(synopsis)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(6)
                .lineLimit(
                    isExpanded
                    ? nil
                    : Constants.collapsedLineLimit
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            
        } else {
            
            Text("No hay una synopsis disponible para este manga.")
                .font(.body)
                .foregroundStyle(.secondary)
                .italic()
        }
    }
    
    // MARK: - Expand Button
    
    private var expandButton: some View {
        
        Button {
            
            withAnimation(
                .easeInOut(duration: 0.25)
            ) {
                isExpanded.toggle()
            }
        } label: {
            
            Text(
                isExpanded
                ? "Leer menos"
                : "Leer más"
            )
            .font(.body)
            .fontWeight(.medium)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.blue)
    }
    
    // MARK: - Helpers
    
    private var synopsis: String? {
        
        guard let synopsis = manga.sypnosis else { return nil }
        
        let trimmedSynopsis = synopsis.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        return trimmedSynopsis.isEmpty
        ? nil
        : trimmedSynopsis
    }
    
    private var hasSynopsis: Bool {
        
        synopsis != nil
    }
}
