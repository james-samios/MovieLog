//
//  SeenMovieController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 15/5/2022.
//

import Foundation
import UIKit

class SeenMovieController: UIViewController {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYearGenre: UILabel!
    @IBOutlet var movieBlurb: UILabel!
    @IBOutlet var movieRating: UILabel!
    @IBOutlet var movieComment: UILabel!
    @IBOutlet var edit: UIButton!
    
    @IBOutlet var likeButton: UIImageView!
    @IBOutlet var editButton: UIButton!
    
    var currentRating: String = ""
    var currentComment: String = ""
    
    private var movie: Movie? = nil
    let errorMsg = "N/A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply rounding to the edit button and set text colour to white.
        editButton.layer.cornerRadius = 15
        editButton.titleLabel?.textColor = .white
        
        // Get LoggedMovie data for current rating and comment.
        let loggedMovie = DBConnector.instance.getLoggedMovie(movie: self.movie!)
        currentRating = loggedMovie?.rating ?? errorMsg
        currentComment = loggedMovie?.summary ?? errorMsg
        
        // Set labels to movie information.
        self.title = movie?.title ?? "Error when loading movie!"
        
        movieBlurb.text = movie?.overview ?? errorMsg
        movieYearGenre.text = movie?.getFormattedReleaseDate() ?? errorMsg
        moviePoster = movie?.setPoster(image: moviePoster)
        
        movieRating.text = currentRating
        movieComment.text = currentComment
        if (movie == nil) {
            return
        }
        guard movie!.getGenres().indices.contains(0) else { return }
        movieTitle.text = movie?.getGenres()[0]
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.toggleFavourite))
        likeButton.addGestureRecognizer(tapGR)
        likeButton.isUserInteractionEnabled = true
        
        onScreenLoad()
    }
    
    func setMovie(movie: Movie?) {
        if movie != nil {
            self.movie = movie
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Before the view appears
        super.viewWillAppear(animated)
        if movie != nil {
            onScreenLoad()
        }
    }
    
    func onScreenLoad() { //Toggle if the heart button is favourited
        let isFavourited : Bool = DBConnector.instance.isMovieFavourited(movie: movie!);
        if(!isFavourited){
            likeButton.tintColor = UIColor.lightGray
            likeButton.image = UIImage(systemName: "heart")
        }
        else{
            likeButton.tintColor = UIColor.systemPink
            likeButton.image = UIImage(systemName: "heart.fill")
        }
    }
    
    /// Toggles a movie as the favourite one.
    @objc func toggleFavourite(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            if movie != nil {
                let isFavourited: Bool = DBConnector.instance.isMovieFavourited(movie: movie!);
                if isFavourited {
                    likeButton.tintColor = UIColor.lightGray
                    likeButton.image = UIImage(systemName: "heart")
                }
                else {
                    likeButton.tintColor = UIColor.systemPink
                    likeButton.image = UIImage(systemName: "heart.fill")
                }
                // Toggle if the favourite is in the favourited list or not
                DBConnector.instance.toggleFavourite(mode: isFavourited, movie: movie!)
                
            }
        }
    }
    
    @IBAction func editMovie(_ sender: UIButton) { //If the edit button is selected
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditMovieController") as? EditMovieController {
            vc.setMovie(movie: movie)
            vc.currentRating = currentRating
            vc.currentComment = currentComment
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
