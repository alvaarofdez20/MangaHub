//
//  ReadingProgressView.swift
//  MangaHub
//

import SwiftUI

/// Permite consultar y modificar el progreso de lectura del manga.

struct ReadingProgressView: View {
    
    // MARK: - Properties
    
    /// ViewModel que contiene el estado y las acciones del detalle.
    let viewModel: MangaDetailViewModel
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            
            header
            
            progressInformation
            
            volumesControls
        }
        .padding(AppSpacing.medium)
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
        )
    }
}

// MARK: - Subviews

private extension ReadingProgressView {
    
    /// Título y descripción del progreso.
    var header: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            
            Label(
                "Progreso de lectura",
                systemImage: "bookmark.fill"
            )
            .font(.headline)
        }
    }
    
    /// Muestra la barra y el texto correspondiente al progreso actual.
    var progressInformation: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.small
        ) {
            
            HStack {
                
                Text(progressDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(progressCounter)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            if viewModel.ownedVolumes > 0 {
                
                ProgressView(
                    value: Double(viewModel.readingVolume),
                    total: Double(viewModel.ownedVolumes)
                )
                .accessibilityLabel("Progreso de lectura")
                .accessibilityValue("\(viewModel.readingVolume) de \(viewModel.ownedVolumes) tomos en posesión")
            }
        }
    }
    
    /// Controles para avanzar o retroceder en el progreso de lectura.
    var volumesControls: some View {
        
        HStack(
            spacing: AppSpacing.medium
        ) {
            
            Button {
                
                viewModel.decrementReadingVolume()
            } label: {
                
                Image(systemName: "minus")
                    .frame(
                        width: 44,
                        height: 44
                    )
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.readingVolume == 0)
            .accessibilityLabel("Retroceder un tomo")
            
            Spacer()
            
            VStack(
                spacing: AppSpacing.extraSmall
            ) {
                
                Text(currentVolumeTitle)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                if viewModel.ownedVolumes > 0 {
                    
                    Text(
                        "de \(viewModel.ownedVolumes)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                
                viewModel.incrementReadingVolume()
            } label: {
                
                Image(systemName: "plus")
                    .frame(
                        width: 44,
                        height: 44
                    )
            }
            .buttonStyle(.borderedProminent)
            .disabled(hasReachedMaximumVolume)
            .accessibilityLabel("Avanzar un tomo")
        }
    }
}

// MARK: - Computed Properties

private extension ReadingProgressView {
    
    /// Texto descriptivo según el progreso actual.
    var progressDescription: String {
        
        if viewModel.ownedVolumes == 0 {
            return "Añade tomos a tu colección para registrar la lectura."
        }
        
        if viewModel.readingVolume == 0 {
            return "Todavía no has empezado este manga."
        }
        
        if hasReachedMaximumVolume {
            return "Has leído todos los tomos que tienes."
        }
        
        return "Leyendo el tomo \(viewModel.readingVolume)."
    }
    
    /// Texto mostrado en la parte derecha de la barra.
    var progressCounter: String {
        
        "\(viewModel.readingVolume) de \(viewModel.ownedVolumes)"
    }
    
    /// Texto principal del volumen actual.
    var currentVolumeTitle: String {
        
        if viewModel.readingVolume == 0 {
            return "Sin empezar"
        }
        
        return "Tomo \(viewModel.readingVolume)"
    }
    
    /// Indica si se ha alcanzado el último tomo.
    var hasReachedMaximumVolume: Bool {
        
        return viewModel.readingVolume >= viewModel.ownedVolumes
    }
}
