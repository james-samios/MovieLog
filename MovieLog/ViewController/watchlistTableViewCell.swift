//
//  WatchlistTableViewCell.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 16/5/2022.
//

import Foundation
import UIKit

class WatchlistTableViewCell: UITableViewCell {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieName: UILabel!
    
    func setWatchlistCell (movie: String) {
        movieName.text = movie
    }
    
}
