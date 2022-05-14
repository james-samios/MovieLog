//
//  Movie.swift
//  MovieLog
//
//  Created by James Samios on 10/5/2022.
//

import Foundation

struct Movie: Decodable {
    
    let id: Int
    let title: String
    let overview: String?
    let vote_average: Float
    let vote_count: Int
    let poster_path: String
    let adult: Bool
    let release_date: Date // yy mm dd
    let original_language: String
    let genre_ids: [Int]
    
    func getPosterUrl() -> String {
        return "https://image.tmdb.org/t/p/original/\(poster_path)"
    }
}
