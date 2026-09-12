//
//  Title.swift
//  movie
//
//  Created by aditya on 09/08/26.
//

import Foundation

struct ApiObject : Decodable {
    var results : [Movie] = []
}

struct Movie : Decodable, Identifiable {
    var id : Int?
    var title : String?
    var backdrop_path : String?
    var poster_path : String?
    var vote_average : Double?
    var vote_count : Int?
    var release_date : String?
    var genre_ids : [Int]?
    var overview : String?
    
    static var previewTitles = [
        Movie(id: 1, title: "BeetleJuice", backdrop_path: Constans.imagesList[0], poster_path: Constans.imagesList[0], vote_average: 7.5, vote_count: 1200, release_date: "1988-09-30", genre_ids: [35, 14], overview: "A movie about BeetleJuice A movie about BeetleJuice A movie about BeetleJuice A movie about BeetleJuice A movie about BeetleJuice A movie about BeetleJuice A movie about BeetleJuice A movie about BeetleJuice"),
        Movie(id: 2, title: "Pulp Fiction", backdrop_path: Constans.imagesList[1], poster_path: Constans.imagesList[1], vote_average: 8.9, vote_count: 24000, release_date: "1994-10-14", genre_ids: [80, 53], overview: "A movie about Pulp Fiction"),
        Movie(id: 3, title: "The Dark Knight", backdrop_path: Constans.imagesList[2], poster_path: Constans.imagesList[2], vote_average: 9.0, vote_count: 30000, release_date: "2008-07-18", genre_ids: [28, 80, 18], overview: "A movie about the Dark Knight")
        ]
}
