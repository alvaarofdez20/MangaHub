//
//  APIError.swift
//  MangaHub
//

import Foundation

nonisolated enum APIError: LocalizedError, Equatable, Sendable {

    case invalidURL

    case offline

    case transport(String)

    case invalidResponse

    case unauthorized

    case unexpectedStatus(code: Int, message: String?)

    case decoding(String)
    
    case cancelled

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "The request address is not valid."

        case .offline:
            return "No internet connection. Showing saved data."

        case .transport(let detail):
            return "Connection problem: \(detail)"

        case .invalidResponse:
            return "The server response was not valid."

        case .unauthorized:
            return "Your session has expired. Please sign in again."

        case .unexpectedStatus(let code, let message):
            return message ?? "Unexpected server error (\(code))."

        case .decoding(let detail):
            return "Could not read the server data: \(detail)"
            
        case .cancelled:
            return "Cancelled"
        }

    }

}
