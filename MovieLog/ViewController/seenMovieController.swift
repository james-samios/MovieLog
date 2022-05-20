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
    
    var currentPoster = UIImage()
    var currentBlurb : String = ""
    var currentTitle : String = ""
    var currentRating: String = ""
    var currentComment: String = ""
    var currentYearGenre: String = ""
    
    
    var movie: Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = movie?.title ?? "Error when loading movie!"
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.toggleFavourite))
        likeButton.addGestureRecognizer(tapGR)
        likeButton.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        movieTitle.text = currentTitle
        movieBlurb.text = currentBlurb
        movieRating.text = currentRating
        movieComment.text = currentComment
        movieYearGenre.text = currentYearGenre
        
        if(movie != nil){
            moviePoster = movie!.setPoster(image: moviePoster)
            onScreenLoad()
        }
    }
    
    func setMovie(movie: Movie?) {
        if movie != nil {
            self.movie = movie
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Before the view appears
        super.viewWillAppear(animated)
        if(movie != nil){
            onScreenLoad()
        }
    }
    
    func onScreenLoad() { //Toggle if the heart button is favourited
        let isFavourited : Bool = DBConnector.instance.isMovieFavourited(movie: movie!);
        if(!isFavourited){
            likeButton.tintColor = UIColor.lightGray
        }
        else{
            likeButton.tintColor = UIColor.systemPink
        }
    }
    
    @objc func toggleFavourite(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            
            if(movie != nil){
                let isFavourited: Bool = DBConnector.instance.isMovieFavourited(movie: movie!);
                if(isFavourited){
                    likeButton.tintColor = UIColor.lightGray
                    //Unfavorite the movie
                }
                else{
                    likeButton.tintColor = UIColor.systemPink
                }
                //Toggle if the favourite is in the favourited list or not
                DBConnector.instance.toggleFavourite(mode: isFavourited, movie: movie!)
                
            }
        }
    }
    
    @IBAction func editMovie(_ sender: UIButton) { //If the edit button is selected
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditMovieController") as? EditMovieController {
            vc.setMovie(movie: movie)
            vc.currentRating = currentRating
            vc.currentComment = currentComment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
