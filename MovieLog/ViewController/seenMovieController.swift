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
    
    var currentMovie: LoggedMovie? = nil
    var currentPoster = UIImage()
    var currentBlurb : String = ""
    var currentTitle : String = ""
    var currentRating: String = ""
    var currentComment: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieTitle.text = currentTitle
        moviePoster.backgroundColor = .red
        movieBlurb.text = currentBlurb
        movieRating.text = currentRating
        movieComment.text = currentComment
    }
    
    @IBAction func editMovie(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "editMovieController") as? editMovieController {
            //vc.poster = UIImage(named: logData[indexPath.row])
            vc.currentTitle = currentTitle
            vc.currentBlurb = currentBlurb
            vc.currentRating = currentRating
            vc.currentComment = currentComment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
