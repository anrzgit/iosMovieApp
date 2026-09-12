//
//  TitleDetailView.swift
//  movie
//
//  Created by aditya on 26/08/26.
//

import SwiftUI

struct MovieDetailView: View {
    let title : Movie
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 10){
                AsyncImage(url: URL(string: title.poster_path ?? "")){image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
                        .ignoresSafeArea(edges: .top)
                        
                }placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.3))
                }
                Text(self.title.title ?? "null")
                    .textCase(.uppercase)
                Text(self.title.overview ?? "null")
            }
        }
    }
}

#Preview {
    MovieDetailView(title: Movie.previewTitles[0])
}

