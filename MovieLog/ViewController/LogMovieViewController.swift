//
//  SavedViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit
import Kingfisher


class LogMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var logTableView: UITableView!
    
    var LoggedMovies:[LoggedMovie] = []
    
    //TO BE REPLACED WITH IMDB DATA
    let logData = ["first", "second", "third", "fourth"]
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        logTableView.delegate = self
        logTableView.dataSource = self
        
        let movie:LoggedMovie = LoggedMovie(movie: DBConnector.instance.getFavouriteMovies()[0], summary: "Sonic Is a movie", rating: "5/10")
        DBConnector.instance.logNewMovie(newMovie: movie)
        self.LoggedMovies = DBConnector.instance.getLoggedMovies()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoggedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = LoggedMovies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell") as! LogTableViewCell
        
        cell.setLogCell(loggedMovie: movie)
        
        let posterView = cell.imgPoster!
        
        let poster = movie.movie.getPosterUrl()
        if (poster.isEmpty) {
            // unavailable image to be set here.
            return cell
        }
        let url = URL(string: movie.movie.getPosterUrl())
        let processor = DownsamplingImageProcessor(size: posterView.bounds.size)
        posterView.kf.indicatorType = .activity
        posterView.kf.setImage(
            with: url,
            //placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.imgPoster = posterView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "seenMovieController") as? seenMovieController {
//            vc.poster = UIImage(named: logData[indexPath.row])
            let loggedMovie = LoggedMovies[indexPath.row]
            let movie = loggedMovie.movie;
            vc.currentTitle = movie.title
            vc.currentComment = loggedMovie.summary
            vc.currentRating = loggedMovie.rating
            vc.currentBlurb = "Placeholder Blurb"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    @IBAction func goToWatchlist(_sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "watchlistController") as? watchlistController {
            //vc.poster = UIImage(named: logData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

