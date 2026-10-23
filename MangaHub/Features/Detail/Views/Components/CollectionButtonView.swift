//
//  CollectionButtonView.swift
//  MangaHub
//

import SwiftUI

struct CollectionButtonView: View {
    
    // MARK: - Properties
    
    /// Acción al pulsar el botón
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        
        Button {
            action()
        } label: {
            
            Label(
                "Añadir a mi colección",
                systemImage: "plus.circle.fill"
            )
            .font(.headline)
            .fontWeight(.bold)
            .frame(
                maxWidth: .infinity
            )
            .padding(.vertical, AppSpacing.large)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.black.opacity(0.75))
        .background(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
            .fill(Color.orange)
        )
        .contentShape(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
        )
    }
}

