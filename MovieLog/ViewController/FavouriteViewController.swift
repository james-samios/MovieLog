//
//  File.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit
import SwiftUI


class FavouriteViewController: UIViewController {
   
    var favouriteMovies: [Movie] = []
    @IBOutlet var favouriteTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favouriteMovies = DBConnector.instance.getFavouriteMovies()
        self.favouriteTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteMovies = DBConnector.instance.getFavouriteMovies()
        self.favouriteTableView.reloadData()
    }
    

}



extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
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
}


class FavouriteViewCell: UITableViewCell {
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblGenre: UILabel!
}
