//
//  Error.swift
//  movie
//
//  Created by aditya on 09/08/26.
//

import Foundation

enum ApiConFigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .dataLoadingFailed(underlyingError: let error):
            return "Failed to load data: \(error.localizedDescription)"
        case .decodingFailed(underlyingError: let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(underlyingError: Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(underlyingError: let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}
