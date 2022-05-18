//
//  editMovieController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 16/5/2022.
//

import Foundation
import UIKit

class editMovieController: UIViewController {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYearGenre: UILabel!
    @IBOutlet var movieBlurb: UILabel!
    @IBOutlet var movieRating: UITextField!
    @IBOutlet var movieComment: UITextField!
    
    //var currentPoster: UIImageView
    var currentMovie: LoggedMovie? = nil
    var currentTitle: String = ""
    var currentBlurb: String = ""
    var currentRating: String = ""
    var currentComment: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = currentTitle
        movieBlurb.text = currentBlurb
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
    }
    
    @IBAction func saveMovie(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "seenMovieController") as? seenMovieController {
            //vc.poster = UIImage(named: logData[indexPath.row])
            vc.currentTitle = currentTitle
            vc.currentBlurb = currentBlurb
            vc.currentRating = movieRating.text!
            vc.currentComment = movieComment.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
