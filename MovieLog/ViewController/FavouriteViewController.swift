//
//  File.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit
import Kingfisher
import SwiftUI


class FavouriteViewController: UIViewController {
   
    var favouriteMovies: [Movie] = []
    var testMovies: [Movie] = []
    @IBOutlet var favouriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //THIS CAN ALL BE DELETED WHEN ADD FAVOURITE BUTTON IS IN
        DBConnector.instance.getPopularMovies(callback: {
            apiMovies in
            self.testMovies = apiMovies
            for movie in self.testMovies {
                DBConnector.instance.addFavouriteMovie(newMovie: movie)
            }
            self.favouriteMovies = DBConnector.instance.getFavouriteMovies()
            DispatchQueue.main.async {
                self.favouriteTableView.reloadData()
            }
        })
        //TO HERE
        
    }


}



extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("=========COUNT======\(favouriteMovies.count)")
        return favouriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteViewCell
            let score = favouriteMovies[indexPath.row]
        cell.lblTitle.text = "\(score.title) (\(score.getReleaseYear()))"
        cell.lblRating.text = String(score.vote_average)
        cell.lblSummary.text = score.overview
        cell.lblGenre.text = "GENRE \(score.genre_ids)"
        
        let posterView = cell.imgPoster!
        
        let poster = score.getPosterUrl()
        if (poster.isEmpty) {
            // unavailable image to be set here.
            return cell
        }
        let url = URL(string: score.getPosterUrl())
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
//        else {
//            fatalError("unable to produce favourite list")
//        }
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
