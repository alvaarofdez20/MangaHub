//
//  MockMangaRepository.swift
//  MangaHub
//

import Foundation

@MainActor
struct MockMangaRepository: MangaRepository {
    
    // MARK: - Properties
    let response: MangaResponse
    
    // MARK: - MangaRespository
    func fetchMangas(
        page: Int,
        per: Int
    ) async throws -> MangaResponse {
        response
    }
    
    func searchMangas(
        criteria: CustomSearch,
        page: Int,
        per: Int
    ) async throws -> MangaResponse {
        response
    }
    
    func fetchManga(
        id: Int
    ) async throws -> Manga {
        
        guard let manga = response.items.first(
            where : { $0.id == id }
        ) else {
            
            throw NSError(
                domain: "MockMangaRepository",
                code: 404,
                userInfo: [
                    NSLocalizedDescriptionKey: "No existe un manga con id \(id)"
                ]
            )
        }
        
        return manga
    }
}
