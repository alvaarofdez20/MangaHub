//
//  MangaDetailHeaderView.swift
//  MangaHub
//

import SwiftUI

struct MangaDetailHeaderView: View {
    
    // MARK: - Properties
    
    /// Manga mostrado en la cabecera
    let manga: Manga
    
    private enum Constants {
        
        /// Altura para todas las cabeceras
        static let artworkHeight: CGFloat = 460
        
        /// Altura para todas las portadas
        static let coverHeight: CGFloat = 400
        
        /// Proporción estándar
        static let coverAspectRatio: CGFloat = 2 / 3
        
        /// Desenfoque fondo
        static let backgroundBlurRadius: CGFloat = 30

    }
    
    // MARK: - Body
    
    var body: some View {
        
        VStack (
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            
            artwork
            
            information
            
        }
    }
    
    // MARK: - Artwork
    
    private var artwork: some View {
        
        ZStack {
            
            blurredBackground
            
            backgroundOverlay
        
            coverImage
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(
            height: Constants.artworkHeight
        )
        .clipped()
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.large
            )
        )
    }
    
    // MARK: - Background
    
    private var blurredBackground: some View {
        
        AsyncImage(
            url: coverURL
        ) { phase in
            
            switch phase {
                
            case .empty:
                
                Color.secondary.opacity(0.12)
                
            case .success(let image):
                
                image
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(1.15)
                    .blur(
                        radius: Constants.backgroundBlurRadius
                    )
                    .scaleEffect(1.15)
                
            case .failure:
                
                Color.secondary.opacity(0.15)
                
            default:
                
                Color.secondary.opacity(0.15)
                
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .clipped()
    }
    
    // MARK: - Background Overlay
    
    private var backgroundOverlay: some View {
        
        Color.black
            .opacity(0.4)
    }
    
    // MARK: - Cover
    
    private var coverImage: some View {
        
        AsyncImage(
            url: coverURL
        ) {
            phase in
            
            switch phase {
                
            case .empty:
                
                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .background(
                        Color.secondary.opacity(0.12)
                    )
                
            case .success(let image):
                
                image
                    .resizable()
                    .scaledToFit()
                
            case .failure:
                
                Image(
                    systemName: "books.closed"
                )
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .background(
                    Color.secondary.opacity(0.12)
                )
                
            default:
                
                EmptyView()
            }
        }
        .aspectRatio(
            Constants.coverAspectRatio,
            contentMode: .fit
        )
        .frame(
            height: Constants.coverHeight
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppCornerRadius.medium
            )
        )
        .shadow(
            color: .black.opacity(0.4),
            radius: 16,
            y: 8
        )
    }
    
    // MARK: - Information
    
    private var information: some View {
        
        VStack (
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            
            metadata
            
            title
            
            authors
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
    
    // MARK: - Metadata
    
    private var metadata: some View {
        
        Text(metadataText)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color.orange)
            .textCase(.uppercase)
            .lineLimit(1)
    }
    
    // MARK: - Title
    
    private var title: some View {
        
        Text(manga.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .lineLimit(2)
    }
    
    // MARK: - Authors
    
    @ViewBuilder
    private var authors: some View {
        
        if !manga.authors.isEmpty {
            
            Text(authorsText)
                .font(.headline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
    
    // MARK: - Helpers
    
    private var metadataText: String {
        
        var values: [String] = []
        
        if let demographic = manga.demographics.first?.demographic {
            values.append(demographic)
        }
        
        if let genre = manga.genres.first?.genre {
            values.append(genre)
        }
        
        return values.joined(
            separator: " • "
        )
    }
    
    private var authorsText: String {
        
        manga.authors.map { author in
            [
                author.firstName,
                author.lastName
            ]
                .filter { !$0.isEmpty }
                .joined(separator: " ")
        }
        .joined(separator: ", ")
    }
    
    private var coverURL: URL? {
        
        guard let mainPicture = manga.mainPicture else {
            return nil
        }
        
        return URL(
            string: mainPicture
        )
    }
    
    // MARK: - Content
    
    private var content: some View {
        
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            
            coverImage
            
            information
        }
    }
}

#Preview {
    MangaDetailHeaderView(
        manga: Manga.preview
    )
}
