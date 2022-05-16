//
//  SearchViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit
import Kingfisher

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [Movie] = []
   
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        searchBar.addTarget(self, action: #selector(onTextChange(_:)), for: .editingChanged)
        searchBar.delegate = self

        // Set its data source to this class.
        table.dataSource = self
    }
    
    /// Search for movies when text field is modified, and update the table cells.
    @objc func onTextChange(_ sender: UITextField) {
        if (!(searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
            DBConnector.instance.searchForMovies(search: searchBar.text!, callback: {
                apiMovies in
                self.movies = apiMovies
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            })
        } else {
            self.movies = []
            self.table.reloadData()
        }
    }
    
    /// Hide the keyboard when the user taps anywhere outside.
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    /// Hide the keyboard when the user taps the "return" key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // As the table view, how many cell should I display in this section?
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequed a reusable cell from the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewCell
        
        // Updated the UI for this Cell
        let score = movies[indexPath.row]
        
        cell.lblTitle.text = "\(score.title) (\(score.getReleaseYear()))"
        cell.lblRating.text = String(score.vote_average)
        cell.lblSummary.text = score.overview
        cell.lblCategories.text = "TODO"
        
        let posterView = cell.imgPoster!
        
        // Load the image. This is the only time it will need to happen, as it'll get cached for later use.
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
        
        // Return the cell to TableView
        return cell;
        
    }

}

class ViewCell: UITableViewCell {
    
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblCategories: UILabel!
    
}
