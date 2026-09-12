//
//  ApiConfig.swift
//  movie
//
//  Created by aditya on 09/08/26.
//

import Foundation

struct ApiConfig : Decodable {
    let baseUrl : String
    let apiKey : String
    let youTubeApiKey : String
    let youTubeBaseUrl : String
    let youTubeSearchBaseUrl : String
    
    static let shared : ApiConfig? = {
        do {
            let config: ApiConfig = try ApiConfig.laodConfig()
            return config
        } catch {
            print("failed to load config \(error.localizedDescription)")
            return nil
        }
    }()
    
    private static func laodConfig() throws -> ApiConfig {
        guard let url: URL = Bundle.main.url(forResource: "ApiConfig", withExtension: "json") else {
            throw ApiConFigError.fileNotFound
        }
        do {
            let data: Data = try Data(contentsOf: url)
            let config: ApiConfig = try JSONDecoder().decode(ApiConfig.self, from: data)
            return config
        } catch let error as DecodingError {
            throw ApiConFigError.decodingFailed(underlyingError: error)
        } catch {
            throw ApiConFigError.dataLoadingFailed(underlyingError: error)
        }
        
    }
}
