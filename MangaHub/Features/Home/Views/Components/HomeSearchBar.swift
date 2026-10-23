//
//  HomeSearchBar.swift
//  MangaHub
//

import SwiftUI

// Búsqueda reutilizable
struct HomeSearchBar: View {
    
    // MARK: - Binding
    
    // Texto escrito por el usuario
    @Binding var searchText: String
    
    // MARK: - Body
    var body: some View {
        
        HStack(spacing: AppSpacing.small) {
            
            // Icono
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.appTextSecondary)
            
            // Campo de texto
            TextField(
                "Títulos, autores o géneros",
                text: $searchText
            )
            .textFieldStyle(.plain)
            
            // Limpiar búscador
            if !searchText.isEmpty {
                
                Button {
                    searchText = ""
                } label: {
                    
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.appTextSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.large)
        .frame(height: 48)
        .background(
            Color.appCardBackground,
            in: RoundedRectangle(
                cornerRadius: AppCornerRadius.medium,
                style: .continuous
            )
        )
    }
}

#Preview {
    HomeSearchBar(
        searchText: .constant("Monster")
    )
    .padding()
    .background(Color.appBackground)
}
