//
//  SwiftDataCollectionRepository.swift
//  MangaHub
//

import Foundation
import SwiftData

/// Implementación del repositorio de colección utilizando SwiftData.
@MainActor
final class SwiftDataCollectionRepository: CollectionRepository {
    
    // MARK: - Dependences
    
    /// Conexto utilizado para leer y guardar datos.
    private let modelContext: ModelContext
    
    // MARK: - Initializer
    
    init(
        modelContext: ModelContext
    ) {
        self.modelContext = modelContext
    }
    
    // MARK: - Fetch
    
    /// Recupera los mangas guardados.
    func fetchAll() throws -> [CollectedManga] {
        
        let descriptor = FetchDescriptor<CollectedManga>(
            sortBy: [
                SortDescriptor(
                    \CollectedManga.addedAt,
                     order: .reverse
                )
            ]
        )
        
        return try modelContext.fetch(descriptor)
    }
    
    /// Busca un manga mediante su ID.
    func fetchManga(
        mangaId: Int
    ) throws -> CollectedManga? {
        
        let descriptor = FetchDescriptor<CollectedManga>(
            predicate: #Predicate { collectedManga in
                collectedManga.mangaId == mangaId
            }
        )
            
        return try modelContext.fetch(descriptor).first
    }
    
    /// Comprueba si un manga está guardado.
    func contains(
        mangaId: Int
    ) throws -> Bool {
        
        try fetchManga(
            mangaId: mangaId
        ) != nil
    }
    
    // MARK: - Insert
    
    /// Añade un manga a la colección.
    @discardableResult
    func add(
        manga: Manga
    ) throws -> CollectedManga {
        
        guard try !contains(
            mangaId: manga.id
        ) else {
            throw CollectionRepositoryError.mangaAlreadyExists
        }
        
        let collectedManga = CollectedManga(
            mangaId: manga.id,
            title: manga.title,
            coverURL: manga.mainPicture,
            totalVolumes: manga.volumes
        )
        
        modelContext.insert(collectedManga)
        
        try save()
        
        return collectedManga
    }
    
    // MARK: - Delete
    
    /// Elimina un manga de la colección.
    func remove(
        mangaId: Int
    ) throws {
        
        guard let collectedManga = try fetchManga(
            mangaId: mangaId
        ) else {
            throw CollectionRepositoryError.mangaNotFound
        }
        
        modelContext.delete(collectedManga)
        
        try save()
    }
    
    // MARK: - Save
    
    /// Guarda los cambios pendientes.
    func save() throws {
        
        guard modelContext.hasChanges else { return }
        
        try modelContext.save()
    }
}
