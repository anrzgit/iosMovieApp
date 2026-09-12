//
//  TrendingMoviesHorizontalView.swift
//  movie
//
//  Created by aditya on 02/08/26.
//

import SwiftUI

struct TrendingMoviesHorizontalView: View {
    var header: String
    @State private var viewModel = MovieViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.title)
                .fontWeight(.light)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(viewModel.trendingMoviesList) { movie in
                        NavigationLink (destination: MovieDetailView(movie: movie)) {
                            AsyncImage(url: URL(string: movie.poster_path ?? "")) { downloadedImage in
                                downloadedImage
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 150)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 200)
        .onAppear { viewModel.fetchMovies() }
    }
}

#Preview {
    TrendingMoviesHorizontalView(header: Constans.upcomingString)
}
