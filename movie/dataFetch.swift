//
//  dataFetch.swift
//  movie
//
//  Created by aditya on 09/08/26.
//

import Foundation 

let bseUrl: String? = ApiConfig.shared?.baseUrl
let apiKey: String? = ApiConfig.shared?.apiKey
let youTubeApiKey: String? = ApiConfig.shared?.youTubeApiKey
let youTubeBaseUrl: String? = ApiConfig.shared?.youTubeBaseUrl
let youTubeSearchBaseUrl: String? = ApiConfig.shared?.youTubeSearchBaseUrl 

//https://api.themoviedb.org/3/trending/movie/day?language=en-US

struct DataFetcher{
    func fetchMovies(for media : String, by type : String) async throws -> Result<[Movie], Error>{
        
        guard let apiKey: String = apiKey else {
            throw NetworkError.invalidURL
        }
        
        guard let url = try buildUrl(media: media, type: type) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            var titles = try JSONDecoder().decode(ApiObject.self, from: data).results
            Constans.addPosterPath(to: &titles)
            return .success(titles)
        } catch {
            return .failure(error)
        }
    }
    
    private func buildUrl (media : String, type : String) throws -> URL?{
       
        guard let baseUrl = bseUrl else {
            throw NetworkError.invalidURL
        }
        
        var path : String
        
        if type == "popular" {
            path = "3/\(media)/popular?language=en-US"
        } else if type == "upcoming" {
            path = "3/\(media)/upcoming?language=en-US"
        } else if type == "trending" {
            path = "3/trending/\(media)/day?language=en-US"
        } else if type == "top_rated" {
            path = "3/\(media)/top_rated?language=en-US"
        } else if type == "now_playing" {
            path = "3/\(media)/now_playing?language=en-US"
        } else {
            throw NetworkError.invalidURL
        }
        return URL(string: "\(baseUrl)/\(path)")
    }

    func fetchVideoId(for videoName : String) async throws -> Result<String, Error> {
        guard let youTubeApiKey: String = youTubeApiKey else {
            throw NetworkError.invalidURL
        }
        
        guard let youTubeBaseUrl: String = youTubeBaseUrl else {
            throw NetworkError.invalidURL
        }
        
        guard let youTubeSearchBaseUrl: String = youTubeSearchBaseUrl else {
            throw NetworkError.invalidURL
        }
        
        guard let encodedVideoName = videoName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }

        let urlString: String = "\(youTubeSearchBaseUrl)?part=snippet&type=video&q=\(encodedVideoName)&key=\(youTubeApiKey)"

        guard let url: URL = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let videoId = try JSONDecoder().decode(YouTubeApiObject.self, from: data).items.first?.id.videoId ?? ""
            return .success(videoId)
        } catch {
            return .failure(error)
        }
    }
}

