//
//  youTubeApiObject.swift
//  movie
//
//  Created by aditya on 09/08/26.
//

import Foundation

struct YouTubeApiObject: Decodable {
    let items: [Item]

    struct Item: Decodable {
        let id: VideoId
    }

    struct VideoId: Decodable {
        let videoId: String
    }
}
