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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviePoster.backgroundColor = .red
        movieComment.text = "The Book of Genesis is the first book of the Hebrew Bible and the Christian Old Testament. Its Hebrew name is the same as its first word, Bereshit. Genesis is an account of the creation of the world, the early history of humanity, and of Israel's ancestors and the origins of the Jewish people."
    }
}
