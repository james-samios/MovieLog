//
//  LogTableViewCell.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 15/5/2022.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet var movieName: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblGenre: UILabel!
    
    //TO BE CHANGED TO A METHOD THAT USES Movie AS A PARAMETER
    func setLogCell(loggedMovie: LoggedMovie) {
        let movie = loggedMovie.movie
        movieName.text = movie.title
        lblYear.text = movie.getReleaseYear()
        lblReview.text = loggedMovie.summary
        lblRating.text = loggedMovie.rating
        lblGenre.text = "GENRE"
        
        
    }
    
    

}
