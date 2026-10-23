//
//  MangaDetailViewModel.swift
//  MangaHub
//

import Foundation
import Observation

@Observable
@MainActor
final class MangaDetailViewModel {
    
    // MARK: - Dependences
    
    /// Repositorio encargado de gestionar la colección local del usuario.
    private let collectionRepository: any CollectionRepository
    
    // MARK: - Properties
    
    /// Manga que se mostrará
    private(set) var manga: Manga
    
    /// Manga almacenado localmente en SwiftData.
    private var collectedManga: CollectedManga?
    
    // MARK: - Collection State
    
    /// Indica si tiene la colección completa
    private(set) var isCollectionComplete = false
    
    /// Número de tomos que posee
    private(set) var ownedVolumes = 0
    
    /// Último tomo alcanzado por el usuario.
    private(set) var readingVolume = 0
    
    /// Puntuación personal del usuario
    private(set) var personalRating = 0
    
    /// Indica si el manga está en tu colección
    private(set) var isInCollection = false
    
    /// Mensaje de error relacionado con la colección.
    private(set) var collectionErrorMessage: String?
    
    // MARK: - Initializer
    
    /// Crea el ViewModel con el manga seleccionado
    init(
        manga: Manga,
        collectionRepository: any CollectionRepository
    ) {
        self.manga = manga
        self.collectionRepository = collectionRepository
        
        loadCollectionState()
    }
    
    // MARK: - Collection Actions
    
    /// Carga el estado persistido del manga.
    func loadCollectionState() {
        
        do {
            
            let collectedManga = try collectionRepository.fetchManga(
                mangaId: manga.id
            )
            
            self.collectedManga = collectedManga
            isInCollection = collectedManga != nil
            
            guard let collectedManga else {
                resetCollectionState()
                return
            }
            
            applyCollectionState(from: collectedManga)
            
            collectionErrorMessage = nil
            
        } catch {
            
            collectionErrorMessage = error.localizedDescription
            
        }
    }
    
    /// Cambia el estado de la colección
    func setCollectionComplete(
        _ isComplete: Bool
    ) {
        
        isCollectionComplete = isComplete
        
        /// Si el manga se marca como seleccionado,
        /// se cambia el número de tomos a todos los que se conozcan
        if isComplete {
            
            let totalVolumes = manga.volumes
            ownedVolumes = totalVolumes ?? 0
        }
        
        persistCollectionChanges()
    }
    
    /// Aumentar el número de tomos
    func incrementOwnedVolumes() {
        
        /// El usuario no puede poner mas tomos de los que se conozcan
        if let totalVolumes = manga.volumes {
            
            guard ownedVolumes < totalVolumes else { return }
        }
        
        ownedVolumes += 1
        
        updateCollectionCompleteState()
        persistCollectionChanges()
    }
    
    /// Reduce el número de tomos
    func decrementOwnedVolumes() {
        
        /// El usuario no puede tener tomos negativos
        guard ownedVolumes > 0 else { return }
        
        ownedVolumes -= 1
        
        readingVolume = min(
            readingVolume,
            ownedVolumes
        )
        
        updateCollectionCompleteState()
        persistCollectionChanges()
    }
    
    /// Guarda la puntuación personal
    func setPersonalRating(
        _ rating: Int
    ) {
        
        /// Limitamos el valor
        personalRating = min(
            max(rating, 0),
            5
        )
        
        persistCollectionChanges()
    }
    
    /// Añade el manga a la colección
    func addToCollection() {
        
        do {
            
            let collectedManga = try collectionRepository.add(
                manga: manga
            )
            
            self.collectedManga = collectedManga
            isInCollection = true
            
            applyCollectionState(from: collectedManga)
            
            collectionErrorMessage = nil
            
        } catch {
            
            collectionErrorMessage = error.localizedDescription
        }
        
    }
    
    /// Elimina el manga de la colección
    func removeFromCollection() {
        
        do {
            
            try collectionRepository.remove(
                mangaId: manga.id
            )
            
            collectedManga = nil
            isInCollection = false
            
            resetCollectionState()
            collectionErrorMessage = nil
        } catch {
            
            collectionErrorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Private Helpers
    
    private func updateCollectionCompleteState() {
        
        guard let totalVolumes = manga.volumes else {
            
            isCollectionComplete = false
            return
        }
        
        isCollectionComplete =
            totalVolumes > 0 &&
            ownedVolumes == totalVolumes
    }
    
    /// Copia el estado actual al modelo persistente y guarda los cambios en SwiftData.
    private func persistCollectionChanges() {
        
        guard let collectedManga else {
            return
        }
        
        do {
            
            /// Actualizamos el modelo gestionado por SwiftData.
            collectedManga.ownedVolumes = ownedVolumes
            collectedManga.readingVolume = readingVolume
            collectedManga.isCollectionComplete = isCollectionComplete
            collectedManga.personalRating = personalRating
            
            try collectionRepository.save()
            collectionErrorMessage = nil
        } catch {
            
            collectionErrorMessage = error.localizedDescription
        }
    }
    
    /// Restablece los valores locales de la colección.
    private func resetCollectionState() {
        
        ownedVolumes = 0
        readingVolume = 0
        isCollectionComplete = false
        personalRating = 0
    }
    
    /// Avanza un tomo en el progeso de lectura.
    func incrementReadingVolume() {
        
        /// Evitamos modificar información de un manga que todavía no pertenece a la colección.
        guard isInCollection else { return }
        
        /// Si conocemos el total de tomos, no permitimos superar ese valor.
        //guard let totalVolumes = manga.volumes, totalVolumes > 0 else { return }
        
        guard readingVolume < ownedVolumes else { return }
        
        readingVolume += 1
        
        persistCollectionChanges()
    }
    
    /// Retrocede un tomo en el progeso de lectura.
    func decrementReadingVolume() {
        
        guard manga.volumes != nil else { return }
        
        /// Evitamos modificar información de un manga que todavía no pertenece a la colección.
        guard readingVolume > 0 else { return }
        
        readingVolume -= 1
        
        persistCollectionChanges()
    }
    
    /// Establece manualmente el tomo actual de lectura.
    func setReadingVolume(
        _ volume: Int
    ) {
        
        guard isInCollection else { return }
        
        readingVolume = min(
            max(volume, 0),
            ownedVolumes
        )
        
        persistCollectionChanges()
    }
    
    private func applyCollectionState(
        from collectedManga: CollectedManga
    ) {
        ownedVolumes = collectedManga.ownedVolumes
        readingVolume = collectedManga.readingVolume
        isCollectionComplete = collectedManga.isCollectionComplete
        personalRating = collectedManga.personalRating
    }
}
