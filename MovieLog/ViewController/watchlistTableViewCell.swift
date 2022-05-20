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
    
    func setWatchlistCell (movie: Movie) {
        print("========CELL============")
        movieName.text = movie.title
        moviePoster = movie.setPoster(image: moviePoster)
    }
    
}
