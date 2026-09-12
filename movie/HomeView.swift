//
//  HomeView.swift
//  movie
//
//  Created by aditya on 27/07/26.
//

import SwiftUI

struct HomeView: View {
    let movieViewModel: MovieViewModel
    var movie: Movie? { movieViewModel.heroMovie }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(){
                if let movie {
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        AsyncImage(url: URL(string: movie.poster_path ?? "")){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }placeholder: {
                            ProgressView()
                        }
                    }
                    HStack(){
                        Button(){

                        } label: {
                            Text("Play")
                                .elevatedButton()
                        }
                        Button(){

                        } label: {
                            Text("Download")
                                .outlinedButton()
                        }
                    }
                }
            }
            TrendingMoviesHorizontalView(header: "Trending")
            UpcomingMoviesHorizontalView(header: "Upcoming")
        }.padding(.horizontal, 10)
        
    }
}

#Preview {
    HomeView(movieViewModel: MovieViewModel())
}
