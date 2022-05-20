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
    }
    
    func setMovie(movie: Movie?) {
        if movie != nil {
            self.movie = movie
        }
    }
    
    @IBAction func saveMovie(_ sender: UIButton) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "LogMovieViewController") as? LogMovieViewController {
            if(movie != nil){
                let newMovie:LoggedMovie = LoggedMovie(movie: movie!, summary: movieComment.text!, rating: movieRating.text!)
                DBConnector.instance.logNewMovie(newMovie: newMovie)
            }
            _ = navigationController?.popViewController(animated: true)
            tabBarController!.selectedIndex = 3
            
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
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
