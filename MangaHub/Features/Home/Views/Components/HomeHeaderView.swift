//
//  HomeHeaderView.swift
//  MangaHub
//

import SwiftUI

/// Encabezado de la pantalla principal.
struct HomeHeaderView: View {
    
    // MARK: - Bindings
    
    /// Texto introducido en el buscador.
    @Binding var searchText: String
    
    // MARK: - Body
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            
            /// Título de la pantalla.
            Text("Explorar")
                .font(AppTypography.screenTitle)
                .foregroundStyle(Color.appTextPrimary)
            
            /// Buscador
            HomeSearchBar(
                searchText: $searchText
            )
        }
        .padding(.horizontal, AppSpacing.extraLarge)
        .padding(.top, AppSpacing.large)
    }
}

#Preview {
    
    @Previewable @State var searchText = ""
    
    HomeHeaderView(
        searchText: $searchText
    )
    .background(Color.appBackground)
}
