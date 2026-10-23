//
//  CollectionRepository.swift
//  MangaHub
//

import Foundation

/// Operaciones disponibles para gestionar la colección local.
@MainActor
protocol CollectionRepository {
    
    /// Recupera todos los mangas guardados.
    func fetchAll() throws -> [CollectedManga]
    
    /// Busca un manga por su ID.
    func fetchManga(
        mangaId: Int
    ) throws -> CollectedManga?
    
    /// Comprueba si un manga está en la colección.
    func contains(
        mangaId: Int
    ) throws -> Bool
    
    /// Añade un manga a la colección.
    @discardableResult
    func add(
        manga: Manga
    ) throws -> CollectedManga
    
    /// Elimina un manga de la colección.
    func remove(
        mangaId: Int
    ) throws
    
    /// Guardar cambios.
    func save() throws
}
