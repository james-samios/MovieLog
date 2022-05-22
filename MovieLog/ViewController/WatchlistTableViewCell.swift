//
//  WatchlistTableViewCell.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 16/5/2022.
//


import UIKit

class WatchlistTableViewCell: UITableViewCell {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieName: UILabel!
    @IBOutlet var movieBlurb: UILabel!
    @IBOutlet var movieRating: UILabel!
    @IBOutlet var movieGenre: UILabel!
    
    func setWatchlistCell (movie: Movie) {
        //Set the watchlist card values
        movieName.text = movie.title
        moviePoster = movie.setPoster(image: moviePoster)
        movieBlurb.text = movie.overview
        movieRating.text = String(movie.vote_average)
        guard(movie.getGenres()[0] == nil)
        else{
            movieGenre.text = movie.getGenres()[0]
            return
        }
        
    }
    
}
