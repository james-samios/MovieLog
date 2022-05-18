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
    
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        logTableView.delegate = self
        logTableView.dataSource = self
        

        self.LoggedMovies = DBConnector.instance.getLoggedMovies()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoggedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = LoggedMovies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell") as! LogTableViewCell
        
        cell.setLogCell(loggedMovie: movie)
        
        cell.imgPoster = movie.movie.setPoster(image: cell.imgPoster)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "seenMovieController") as? seenMovieController {
//            vc.poster = UIImage(named: logData[indexPath.row])
            let loggedMovie = LoggedMovies[indexPath.row]
            let movie = loggedMovie.movie
            vc.movie = movie
            vc.currentTitle = movie.title
            vc.currentComment = loggedMovie.summary
            vc.currentRating = loggedMovie.rating
            vc.currentBlurb = movie.overview!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    @IBAction func goToWatchlist(_sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "watchlistController") as? watchlistController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

