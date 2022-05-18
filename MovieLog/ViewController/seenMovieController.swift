//
//  seenMovieController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 15/5/2022.
//

import Foundation
import UIKit

class seenMovieController: UIViewController {
    
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
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.toggleFavourite))
        likeButton.addGestureRecognizer(tapGR)
        likeButton.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        movieTitle.text = currentTitle
        movieBlurb.text = currentBlurb
        movieRating.text = currentRating
        movieComment.text = currentComment
        movieYearGenre.text = currentYearGenre
        moviePoster = movie!.setPoster(image: moviePoster)
        if(movie != nil){
            onScreenLoad()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(movie != nil){
            onScreenLoad()
        }
    }
    
    func onScreenLoad() {
        var isFavourited : Bool = false;
        for film in DBConnector.instance.getFavouriteMovies() {
            print()
            if film.id == movie?.id{
                isFavourited = true;
            }
        }
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
                var isFavourited: Bool = false;
                for film in DBConnector.instance.getFavouriteMovies() {
                    print()
                    if film.id == movie?.id{
                        isFavourited = true;
                    }
                }
                
                DBConnector.instance.toggleFavourite(mode: isFavourited, movie: movie!)
                print("=========PRINTED========")
                if(isFavourited){
                    likeButton.tintColor = UIColor.lightGray
                    print("=========No Longer Favourited========")
                }
                else{
                    print("=========Favourited========")
                    likeButton.tintColor = UIColor.systemPink
                }
                
            }
            else{
                print("=========ISNULL========")
            }
        }
    }
    
    @IBAction func editMovie(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "editMovieController") as? editMovieController {
            //vc.poster = UIImage(named: logData[indexPath.row])
            vc.setMovie(movie: movie)
            vc.currentRating = currentRating
            vc.currentComment = currentComment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
