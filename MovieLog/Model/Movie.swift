//
//  Movie.swift
//  MovieLog
//
//  Created by James Samios on 10/5/2022.
//

import Foundation
import UIKit
import Kingfisher

/// Movie
/// This struct holds information about a movie which is automatically
/// decoded from the API.
struct Movie: Codable {
    
    let id: Int
    let title: String
    let overview: String?
    let vote_average: Float
    let vote_count: Int
    let poster_path: String
    let release_date: String
    let original_language: String
    let genre_ids: [Int]
    
    /// Returns the URL to the poster image.
    func getPosterUrl() -> String {
        return "https://image.tmdb.org/t/p/original/\(poster_path)"
    }
    
    /// Returns the release date in a common format (dd/mm/yyyy)
    func getFormattedReleaseDate() -> String {
        let split = release_date.split(separator: "-")
        guard split.indices.contains(2) else { return "N/A" }
        return "\(split[2])/\(split[1])/\(split[0])"

    }
    
    /// Returns the release year of the movie.
    func getReleaseYear() -> String {
        let split = release_date.split(separator: "-")
        guard split.indices.contains(0) else { return "N/A" }
        return "\(split[0])"
    }
    
    /// Returns the genres associated with the movie.
    func getGenres() -> [String?] {
        var array: [String?] = []
        for genre_id in genre_ids {
            array.append(AppDelegate.instance.getGenreNameById(id: genre_id))
        }
        return array
    }
    
    /// Handles poster views in various parts of the application.
    /// - Parameters:
    ///     - image: The image to be modified
    /// - Returns: The image with the poster applied to it.
    func setPoster(image: UIImageView) -> UIImageView {
        let poster = getPosterUrl()
        if (poster.isEmpty) {
            return image
        }
        let url = URL(string: poster)
        let processor = DownsamplingImageProcessor(size: image.bounds.size) // down-scale the image to the size of the imageview.
            |> RoundCornerImageProcessor(cornerRadius: 15) // apply corner radius for nice ui effect.
        image.kf.indicatorType = .activity // indicator whilst the image is being loaded.
        image.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)), // fade in the image when it is loaded for nice ui effect.
                .cacheOriginalImage // cache the original image so we don't have to keep downloading it (regardless of size)
            ])
        return image
    }
}
