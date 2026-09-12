//
//  constants.swift
//  movie
//
//  Created by aditya on 27/07/26.
//

import Foundation
import SwiftUI

struct Constans {
    static let homeString  = "Home"
    static let searchString = "Search"
    static let upcomingString = "Upcoming"
    static let downloadString = "Downlaod"
    
    
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"
    
    static let imagesList = [
        "https://image.tmdb.org/t/p/w500/ldoY4fTZkGISMidNw60GHoNdgP8.jpg",
        "https://image.tmdb.org/t/p/w500/aMETsaNNcDc6g5ZatQtVbySnSaA.jpg",
        "https://image.tmdb.org/t/p/w500/yUOJHa9XmB1H0iYodG9Kb3YCc9T.jpg",
        "https://image.tmdb.org/t/p/w500/sshNRCbtU2ON8SiWLycQzr05doX.jpg",
        "https://image.tmdb.org/t/p/w500/qjiPP4FhTV3UAGa1Dbf2qEqTvu5.jpg"
    ]
    
    static let posterPathInitUrl = "https://image.tmdb.org/t/p/w500"
    static func addPosterPath(to title: inout[Movie]) {
        for i in title.indices {
            if let posterPath = title[i].poster_path {
                title[i].poster_path = "\(Constans.posterPathInitUrl)/\(posterPath)"
            }
        }
    }
}


extension Text{
    func elevatedButton() -> some View {
        self
            .frame(width: 100, height: 30)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
    }
    
    func outlinedButton() -> some View {
        self
            .frame(width: 100, height: 30)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.buttonBorder, lineWidth: 2)
            }
    }
}
