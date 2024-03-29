//
//  SearchViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [Movie] = []
   
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard dismissal recogniser registration.
        let dismissKbTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKbTap.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKbTap)
        
        // Register the target for when the text is changed in the search field.
        searchBar.addTarget(self, action: #selector(onTextChange(_:)), for: .editingChanged)
        searchBar.delegate = self

        // Set the table's data source to this class.
        table.dataSource = self
        table.delegate = self
    
    }
    
    /// Search for movies when text field is modified, and update the table cells.
    @objc func onTextChange(_ sender: UITextField) {
        if (!(searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) { // If there is actually a search, and not just an empty string or white spaces.
            DBConnector.instance.searchForMovies(search: searchBar.text!, callback: {
                apiMovies in
                self.movies = apiMovies
                DispatchQueue.main.async {
                    // Reload data on main thread.
                    self.table.reloadData()
                }
            })
        } else {
            // No movies found, just reload table with empty array.
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
        cell.imgPoster = score.setPoster(image: cell.imgPoster)
        guard score.getGenres().indices.contains(0) else { return cell }
        cell.lblCategories.text = score.getGenres()[0]
        
        // Return the cell to TableView
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let score = movies[indexPath.row]
        AppDelegate.instance.sendToMovieController(movie: score,
                                                   navigationController: self.navigationController!,
                                                   storyboard: self.storyboard!)
    }
}

class ViewCell: UITableViewCell {
    
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSummary: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblCategories: UILabel!
    
}
