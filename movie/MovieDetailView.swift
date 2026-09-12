//
//  TitleDetailView.swift
//  movie
//
//  Created by aditya on 26/08/26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie : Movie
    @State private var videoId: String? = nil
    var body: some View {
        GeometryReader{ geometry in
            ScrollView {
                VStack(spacing: 10){
                    AsyncImage(url: URL(string: movie.poster_path ?? "")){image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                        //                        .ignoresSafeArea(edges: .top)
                        
                    }placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                    YouTubePlayer(videoId: self.videoId ?? "cxF__10G98M")
                        .frame(height: 220)
                    Text(self.movie.title ?? "null")
                        .textCase(.uppercase)
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                    Text(self.movie.overview ?? "null")
                        .padding(8)
                }
            }
        }
        .onAppear() {
            Task {
                let videoIdResult: Result<String, any Error> = await MovieViewModel().fetchVideoId(for: movie.title ?? "")
                switch videoIdResult {
                case .success(let videoId):
                    print("Fetched Video ID: \(videoId)")
                    self.videoId = videoId
                case .failure(let error):
                    print("Failed to fetch video ID: \(error)")
                }
            }
        }
        
    }
}

#Preview {
    MovieDetailView(movie: Movie.previewTitles[0])
}

