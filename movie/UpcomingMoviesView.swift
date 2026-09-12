//
//  TrendingMoviesHorizontalView.swift
//  movie
//
//  Created by aditya on 02/08/26.
//

import SwiftUI

struct UpcomingMoviesHorizontalView: View {
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
                    ForEach(viewModel.upcomingMoviesList) { title in
                        AsyncImage(url: URL(string: title.poster_path ?? "")) { downloadedImage in
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
