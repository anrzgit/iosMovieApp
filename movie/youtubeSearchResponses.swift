

import Foundation


struct YouTubeSearchResponse : Codable {
    let items : [ItemProperties]?
}

struct ItemProperties : Codable {
    let id : IdProperties?
}

struct IdProperties : Codable {
    let videoID : String?
} 