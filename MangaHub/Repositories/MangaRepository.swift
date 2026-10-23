//
//  MangaRepository.swift
//  MangaHub
//

import Foundation

/// Define las operaciones relacionadas con los mangas.
@MainActor
protocol MangaRepository {
    
    /// Obtiene una página de mangas desde la API.
    func fetchMangas(
        page: Int,
        per: Int
    ) async throws -> MangaResponse
    
    /// Ejecuta la búsqueda avanzada con varios criterios
    func searchMangas(
        criteria: CustomSearch,
        page: Int,
        per: Int
    ) async throws -> MangaResponse
    
    /// Obtiene un manga concreto a partir de su identificador.
    func fetchManga(
        id: Int
    ) async throws -> Manga
}

/// Implementación real del repositorio
@MainActor
final class MangaRepositoryImpl: MangaRepository {
    
    // MARK: - Properties
    
    /// Cliente encargado de ejecutar las peticiones
    private let network: any NetworkClient
    
    // MARK: - Initializer
    
    init(network: any NetworkClient) {
        self.network = network
    }
    
    // MARK: - Fetch Mangas
    
    func fetchMangas(
        page: Int = 1,
        per: Int = 10
    ) async throws -> MangaResponse {
        
        let endpoint = MangaEndpoints.list(
            page: page,
            per: per
        )
        
        return try await network.send(
            endpoint,
            as: MangaResponse.self
        )
    }
    
    // MARK: - Search Mangas
    
    func searchMangas(
        criteria: CustomSearch,
        page: Int = 1,
        per: Int = 20
    ) async throws -> MangaResponse {
        
        let endpoint = try MangaEndpoints.search(
            criteria: criteria,
            page: page,
            per: per
        )
        
        return try await network.send(
            endpoint,
            as: MangaResponse.self
        )
    }
    
    // MARK: - Fetch Manga
    
    /// Obtiene el detalle completo de un manga.
    func fetchManga(
        id: Int
    ) async throws -> Manga {
        
        let endpoint = MangaEndpoints.detail(
            id: id
        )
        
        return try await network.send(
            endpoint,
            as: Manga.self
        )
    }
}
