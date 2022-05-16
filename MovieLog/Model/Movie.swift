//
//  Movie.swift
//  MovieLog
//
//  Created by James Samios on 10/5/2022.
//

import Foundation

struct Movie: Codable {
    
    let id: Int
    let title: String
    let overview: String?
    let vote_average: Float
    let vote_count: Int
    let poster_path: String
    let adult: Bool
    let release_date: String
    let original_language: String
    let genre_ids: [Int]
    
    func getPosterUrl() -> String {
        return "https://image.tmdb.org/t/p/original/\(poster_path)"
    }
    
    func getFormattedReleaseDate() -> String {
        let split = release_date.split(separator: "-")
        guard split.indices.contains(2) else { return "N/A" }
        return "\(split[2])/\(split[1])/\(split[0])"

    }
    
    func getReleaseYear() -> String {
        let split = release_date.split(separator: "-")
        guard split.indices.contains(0) else { return "N/A" }
        return "\(split[0])"
    }
}
