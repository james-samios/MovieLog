//
//  LogTableViewCell.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 15/5/2022.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieName: UILabel!
    
    //TO BE CHANGED TO A METHOD THAT USES Movie AS A PARAMETER
    func setLogCell(movie: String) {
        //moviePoster =
        movieName.text = movie
    }
    
    

}
