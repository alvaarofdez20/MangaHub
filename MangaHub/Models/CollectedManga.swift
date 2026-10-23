//
//  CollectionManga.swift
//  MangaHub
//

import Foundation
import SwiftData

@Model
final class CollectedManga {
    
    // MARK: - Manga Identity
    
    /// Identificador del manga obtenido por la API
    /// Se marca como unico para que no se pueda guardar dos veces
    @Attribute(.unique)
    var mangaId: Int
    
    /// Título del manga
    var title: String
    
    /// Imagen principal del manga
    var coverURL: String?
    
    /// Número total del tomos del manga.
    var totalVolumes: Int?
    
    // MARK: - Collection Info
    
    /// Número de tomos que posee el usuario
    var ownedVolumes: Int
    
    /// Tomo por el que va leyendo el usuario
    var readingVolume: Int
    
    /// Indica si posee la colección completa
    var isCollectionComplete: Bool
    
    /// Puntuación del manga
    var personalRating: Int
    
    /// Fecha en la que se añadió
    var addedAt: Date
    
    // MARK: - Initializer
    
    init(
        mangaId: Int,
        title: String,
        coverURL: String?,
        totalVolumes: Int?,
        ownedVolumes: Int = 0,
        readingVolume: Int = 0,
        isCollectionComplete: Bool = false,
        personalRating: Int = 0,
        addedAt: Date = .now
    ) {
        self.mangaId = mangaId
        self.title = title
        self.coverURL = coverURL
        self.totalVolumes = totalVolumes
        self.ownedVolumes = ownedVolumes
        self.readingVolume = readingVolume
        self.isCollectionComplete = isCollectionComplete
        self.personalRating = personalRating
        self.addedAt = addedAt
    }
    
}
