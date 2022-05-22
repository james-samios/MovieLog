//
//  File.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit
import SwiftUI


class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var favouriteMovies: [Movie] = [] // Array of favourite movies that is loaded every time the view appears.
    @IBOutlet var favouriteTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favouriteMovies = DBConnector.instance.getFavouriteMovies() // Load the favourite movies into the local variable.
        self.favouriteTableView.reloadData() // Reload table data.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteViewCell
            let score = favouriteMovies[indexPath.row]
        cell.lblTitle.text = "\(score.title) (\(score.getReleaseYear()))"
        cell.lblRating.text = String(score.vote_average)
        cell.lblSummary.text = score.overview
        cell.imgPoster = score.setPoster(image: cell.imgPoster)
        guard score.getGenres().indices.contains(0) else { return cell }
        cell.lblGenre.text = score.getGenres()[0]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let score = favouriteMovies[indexPath.row]
        // Send to controller based on logged status.
        AppDelegate.instance.sendToMovieController(movie: score,
                                                   navigationController: self.navigationController!,
                                                   storyboard: self.storyboard!)
    }
}

class FavouriteViewCell: UITableViewCell {
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblGenre: UILabel!
}
