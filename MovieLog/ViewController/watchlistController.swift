//
//  watchlistController.swift
//  MovieLog
//
//  Created by Rebecca Galletta on 16/5/2022.
//

import Foundation
import UIKit

class watchlistController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var watchlistTableView: UITableView!
    
    var watchlist : [String] = ["movie1", "movie2", "movie3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = watchlist[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistTableViewCell") as! watchlistTableViewCell
        
        cell.setWatchlistCell(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "seenMovieController") as? seenMovieController {
            //vc.poster = UIImage(named: logData[indexPath.row])
            vc.currentTitle = watchlist[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
