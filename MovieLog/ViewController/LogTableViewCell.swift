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
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblGenre: UILabel!
    @IBOutlet var btnHeart: UIImageView!
    var movie:Movie!
    //TO BE CHANGED TO A METHOD THAT USES Movie AS A PARAMETER
    func setLogCell(loggedMovie: LoggedMovie) {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.toggleFavourite))
        btnHeart.addGestureRecognizer(tapGR)
        btnHeart.isUserInteractionEnabled = true
        
        let movie = loggedMovie.movie
        movieName.text = movie.title
        lblReview.text = loggedMovie.summary
        lblRating.text = loggedMovie.rating
        
        
        //BAXTER RC
        var isFavourited : Bool = false;
        for film in DBConnector.instance.getFavouriteMovies() {
            print()
            if film.id == movie.id{
                isFavourited = true;
            }
        }
        if(!isFavourited){
            btnHeart.tintColor = UIColor.lightGray
        }
        else{
            btnHeart.tintColor = UIColor.systemPink
        }
        //BAXTER END RC
        
        guard movie.getGenres()[0] == nil
        else {
            lblGenre.text = movie.getGenres()[0]
            return
        }
        
        
    }
    
    @objc func toggleFavourite(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            if(movie != nil){
                var isFavourited: Bool = false;
                for film in DBConnector.instance.getFavouriteMovies() {
                    print()
                    if film.id == movie?.id{
                        isFavourited = true;
                    }
                }
                
                DBConnector.instance.toggleFavourite(mode: isFavourited, movie: movie!)
                if(isFavourited){
                    btnHeart.tintColor = UIColor.lightGray
                }
                else{
                    btnHeart.tintColor = UIColor.systemPink
                }
                
            }
        }
    }
    

}
