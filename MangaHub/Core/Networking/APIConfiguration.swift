//
//  APIConfiguration.swift
//  MangaHub
//

import Foundation

nonisolated struct APIConfiguration: Sendable {
    
    let baseURL: URL

    static let `default` = APIConfiguration(
        baseURL: URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!
    )
    
}
