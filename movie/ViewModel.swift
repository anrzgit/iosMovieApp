//
//  ViewModel.swift
//  movie
//
//  Created by aditya on 09/08/26.
//

import Foundation

@Observable
class MovieViewModel {
    enum fetchState {
        case notStarted
        case loading
        case success
        case failed(underLyingError: Error)
    }
    
    private(set) var homeState : fetchState = .notStarted
    private let dataFetcher = DataFetcher()
    var trendingMoviesList: [Movie] = []
    var popularMoviesList: [Movie] = []
    var topRatedMoviesList: [Movie] = []
    var upcomingMoviesList: [Movie] = []
    var heroMovie: Movie? = nil
    
    func fetchMovies() {
        Task {
            homeState = .loading
            do {
                let trendingMovies = try await dataFetcher.fetchMovies(for: "movie", by: "trending")
                switch trendingMovies {
                case .success(let movies):
                    trendingMoviesList = movies
                    heroMovie = movies.first
                    homeState = .success
                case .failure(let error):
                    homeState = .failed(underLyingError: error)
                }
                
                //popular
                let popularMovies = try await dataFetcher.fetchMovies(for: "movie", by: "popular")
                switch popularMovies {
                case .success(let movies):
                    popularMoviesList = movies
                    homeState = .success
                case .failure(let error):
                    homeState = .failed(underLyingError: error)
                }
                
                //upcoming
                let upcomingMovies = try await dataFetcher.fetchMovies(for: "movie", by: "upcoming")
                switch upcomingMovies {
                case .success(let movies):
                    upcomingMoviesList = movies
                    homeState = .success
                case .failure(let error):
                    homeState = .failed(underLyingError: error)
                }
            } catch {
                print(error)
                homeState = .failed(underLyingError: error)
            }
        }
    }

    func fetchVideoId(for movieTitle: String) async -> Result<String, Error> {
        do {
            let videoIdResult = try await dataFetcher.fetchVideoId(for: movieTitle)
            return videoIdResult
        } catch {
            return .failure(error)
        }
    }
}
