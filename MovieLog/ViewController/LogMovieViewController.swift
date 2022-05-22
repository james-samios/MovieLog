//
//  SavedViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit
import Kingfisher


class LogMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
   
    @IBOutlet var logTableView: UITableView!
    
    var loggedMovies: [LoggedMovie] = []
    
    // RELOAD THE SCREEN EVERY TIME TAB BUTTON IS CLICKED
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        logTableView.delegate = self
        logTableView.dataSource = self
        // Get the movies in the logged list
        self.loggedMovies = DBConnector.instance.getLoggedMovies()
        logTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = loggedMovies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell") as! LogTableViewCell
        
        cell.setLogCell(loggedMovie: movie)
        cell.movie = movie.movie
        cell.imgPoster = movie.movie.setPoster(image: cell.imgPoster)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SeenMovieController") as? SeenMovieController {
            let loggedMovie = loggedMovies[indexPath.row]
            vc.setMovie(movie: loggedMovie.movie)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func goToWatchlist(_sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WatchlistController") as? WatchlistController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

