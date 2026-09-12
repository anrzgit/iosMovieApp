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
}
