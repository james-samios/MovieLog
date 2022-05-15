//
//  notSeenMovieController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 15/5/2022.
//

import Foundation
import UIKit

class notSeenMovieController: UIViewController {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYearGenre: UILabel!
    @IBOutlet var movieBlurb: UILabel!
    @IBOutlet var watchedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
