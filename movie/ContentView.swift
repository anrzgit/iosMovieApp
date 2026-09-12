//
//  ContentView.swift
//  movie
//
//  Created by aditya on 26/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = MovieViewModel()

    var body: some View {
        NavigationStack {
            TabView{
                Tab(Constans.homeString,systemImage: "house"){
                    HomeView(movieViewModel: viewModel)
                }
                Tab(Constans.upcomingString,systemImage: "play.circle"){
                    
                }
                Tab(Constans.searchString,systemImage: "magnifyingglass"){
                    Text("Add page search")
                }
                Tab(Constans.downloadString, systemImage: "arrow.down"){
                    Text("Add page download")
                }
            }.onAppear(){
                if let config = ApiConfig.shared{
                    // print(config.apiKey)
                    // print(config.baseUrl)
                }
                viewModel.fetchMovies()
            }
        }
    }
}

#Preview { 
    ContentView()
}
