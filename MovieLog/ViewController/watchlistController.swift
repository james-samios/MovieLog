//
//  WatchlistController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 16/5/2022.
//

import Foundation
import UIKit

class WatchlistController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var watchlistTableView: UITableView!
    
    var watchlist : [Movie] = DBConnector.instance.getWatchList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchlist = DBConnector.instance.getWatchList()
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        watchlist = DBConnector.instance.getWatchList()
        watchlistTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = watchlist[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistTableViewCell") as! WatchlistTableViewCell
        cell.setWatchlistCell(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = watchlist[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SeenMovieController") as? SeenMovieController {
            vc.setMovie(movie: movie)
            vc.currentBlurb = movie.overview!
            vc.currentRating = String(movie.vote_average)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
