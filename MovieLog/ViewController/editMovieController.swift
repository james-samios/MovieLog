//
//  EditMovieController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 16/5/2022.
//

import Foundation
import UIKit

class EditMovieController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYearGenre: UILabel!
    @IBOutlet var movieBlurb: UILabel!
    @IBOutlet var movieRating: UITextField!
    @IBOutlet var movieComment: UITextField!
    @IBOutlet var imgWatchlist: UIImageView!
    
    var currentRating: String = ""
    var currentComment: String = ""
    
    var movie: Movie? = nil
    let errorMsg = "N/A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = movie?.title ?? "Error when loading movie!"
        
        movieBlurb.text = movie?.overview ?? errorMsg
        movieYearGenre.text = movie?.getFormattedReleaseDate() ?? errorMsg
        moviePoster = movie?.setPoster(image: moviePoster)
        
        if currentRating == "" {
            movieRating.placeholder = "Rating..."
        } else {
            movieRating.text = currentRating
        }
        if currentComment == "" {
            movieComment.placeholder = "Comment..."
        } else {
            movieComment.text = currentComment
        }
        if (movie == nil) {
            return
        }
        guard movie!.getGenres().indices.contains(0) else { return }
        movieTitle.text = movie?.getGenres()[0]
        
        let dismissKbTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKbTap.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKbTap)
        
        //Add selection to watchlist button
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.toggleWatchlist))
        imgWatchlist.addGestureRecognizer(tapGR)
        imgWatchlist.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(movie != nil){
            onScreenLoad()
        }
    }
    
    func onScreenLoad() { // Determine state of watchlist button
        let isSelected : Bool = DBConnector.instance.isMovieInWatchlist(movie: movie!);
       
        if(!isSelected){
            imgWatchlist.tintColor = UIColor.lightGray
        }
        else{
            imgWatchlist.tintColor = UIColor.systemGreen
        }
    }
    
    @objc func toggleWatchlist(sender: UITapGestureRecognizer){
        //If the watchlist button is tapped toggle and add or remove to watchlist
        if sender.state == .ended {
            
            if(movie != nil){
                let isWatched: Bool = DBConnector.instance.isMovieInWatchlist(movie: movie!);
                
                DBConnector.instance.toggleWatchList(mode: isWatched, movie: movie!)
                imgWatchlist.tintColor = isWatched ? UIColor.lightGray : UIColor.systemGreen
            }
        }
    }
    
    
    func setMovie(movie: Movie?) {
        if movie != nil {
            self.movie = movie
        }
    }
    
    @IBAction func saveMovie(_ sender: UIButton) {
        //Fired when the save button is pressed
            if(movie != nil){
                let newMovie:LoggedMovie = LoggedMovie(movie: movie!, summary: movieComment.text!, rating: movieRating.text!)
                DBConnector.instance.logNewMovie(newMovie: newMovie)
            }
            _ = navigationController?.popToRootViewController(animated: true)
        //set the tab to the log tab
            tabBarController!.selectedIndex = 3
            
        
        //RESET ALL TABS BACK TO ROOT
        if let tabVcs = navigationController?.tabBarController?.viewControllers {
                for vc in tabVcs {
                    if let navVc = vc as? UINavigationController {
                        navVc.popToRootViewController(animated: false)
                    }
                }
            }
 
    }
    
    /// Hide the keyboard when the user taps anywhere outside.
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    /// Hide the keyboard when the user taps the "return" key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        movieRating.resignFirstResponder()
        movieComment.resignFirstResponder()
        return true
    }
}
