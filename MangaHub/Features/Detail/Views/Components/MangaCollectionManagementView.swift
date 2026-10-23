//
//  MangaCollectionManagementView.swift
//  MangaHub
//

import SwiftUI

struct MangaCollectionManagementView: View {
    
    // MARK: - Properties
    
    /// Indica si posee todos los mangas
    let isCollectionComplete: Bool
    
    /// Número de tomos que posee
    let ownedVolumes: Int
    
    /// Número total de tomos publicados
    let totalVolumes: Int?
    
    /// Puntuación personal
    let personalRating: Int
    
    /// Acción para cambiar el estado de la colección
    let onCollectionCompleteChanged: (Bool) -> Void
    
    /// Acción para restar tomos del contador
    let onDecrementVolumes: () -> Void

    /// Acción para sumar tomos al contador
    let onIncrementVolumes: () -> Void
    
    /// Acción al seleccionar una puntuación
    let onRatingSelected: (Int) -> Void
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            
            sectionTitle
            
            collectionCard
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
    
    // MARK: - Section Title
    
    private var sectionTitle: some View {
        
        Text("Gestión de colección")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(1.4)
    }
    
    // MARK: - Collection Card
    
    private var collectionCard: some View {
        
        VStack(
            spacing: 0
        ) {
            
            if totalVolumes != nil {
                completeCollectionRow
                
                Divider()
            }
            
            ownedVolumesRow
            
            Divider()
            
            personalRatingRow
        }
        .background(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
            .fill(
                Color(.secondarySystemBackground)
            )
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
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: 4,
            y: 2
        )
    }
    
    // MARK: - Complete Collection Row
    
    private var completeCollectionRow: some View {
        
        HStack(
            spacing: AppSpacing.medium
        ) {
            
            rowIcon(
                systemName: "checkmark.rectangle.stack"
            )
            
            Text("Colección completa")
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Toggle(
                "",
                isOn: Binding(
                    get: { isCollectionComplete },
                    set: { newValue in
                        onCollectionCompleteChanged(
                            newValue
                        )
                    }
                )
            )
            .labelsHidden()
            .tint(.orange)
        }
        .padding(AppSpacing.large)
    }
    
    // MARK: - Owned Volumes Row
    
    private var ownedVolumesRow: some View {
        
        HStack(
            spacing: AppSpacing.medium
        ) {
            
            rowIcon(
                systemName: "book.closed"
            )
            
            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                
                Text("Tomos en posesión")
                    .font(.body)
                    .foregroundStyle(.primary)
                
                if let totalVolumes {
                    
                    Text("\(ownedVolumes) de \(totalVolumes)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            volumesStepper
        }
        .padding(AppSpacing.large)
    }
    
    // MARK: - Volume Stepper
    
    private var volumesStepper: some View {
        
        HStack(
            spacing: AppSpacing.medium
        ) {
            
            Button {
                
                onDecrementVolumes()
                
            } label: {
                
                Image(
                    systemName: "minus"
                )
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(
                    width: 28,
                    height: 28
                )
            }
            .disabled(ownedVolumes == 0)
            
            Text(
                String(ownedVolumes)
            )
            .font(.body.monospacedDigit())
            .fontWeight(.medium)
            .frame(
                minWidth: 28
            )
            
            Button {
                
                onIncrementVolumes()
                
            } label: {
                
                Image(
                    systemName: "plus"
                )
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(
                    width: 28,
                    height: 28
                )
            }
            .disabled(hasReachedVolumesLimit)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.blue)
        .padding(.horizontal, AppSpacing.small)
        .padding(.vertical, AppSpacing.extraSmall)
        .background(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.medium
            )
            .fill(
                Color.secondary.opacity(0.12)
            )
        )
    }
    
    // MARK: - Personal Rating Row
    
    private var personalRatingRow: some View {
        
        HStack(
            spacing: AppSpacing.medium
        ) {
            
            rowIcon(
                systemName: "star"
            )
            
            Text("Mi puntuación")
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            ratingStars
        }
        .padding(AppSpacing.large)
    }
    
    // MARK: - Rating Stars
    
    private var ratingStars: some View {
        
        HStack(
            spacing: AppSpacing.small
        ) {
            
            ForEach(
                1...5,
                id: \.self
            ) { rating in
                
                Button {
                    
                    onRatingSelected(rating)
                    
                } label: {
                    
                    Image(
                        systemName: rating <= personalRating
                        ? "star.fill"
                        : "star"
                    )
                    .font(.title3)
                    .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(
                    "\(rating) de 5 estrellas"
                )
            }
        }
    }
    
    // MARK: - Reusable Row Icon
    
    private func rowIcon(
        systemName: String
    ) -> some View {
        
        Image(
            systemName: systemName
        )
        .font(.title3)
        .foregroundStyle(.secondary)
        .frame(
            width: 26
        )
    }
    
    // MARK: - Helpers
    
    private var hasReachedVolumesLimit: Bool {
        
        guard let totalVolumes else {
            return false
        }
        
        return ownedVolumes >= totalVolumes
    }
    
}
