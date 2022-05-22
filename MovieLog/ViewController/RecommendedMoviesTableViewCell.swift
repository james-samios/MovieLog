//
//  RecommendedMoviesTableViewCell.swift
//  MovieLog
//
//  Created by James Samios on 19/5/2022.
//

import UIKit

class RecommendedMoviesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var movies: [Movie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Load the movies from database.
        loadMovies()
        // Add the notification observer so the cells can be updated when the recommended lists are changed.
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "loadRecommended"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification) {
        loadMovies()
    }
    
    private func loadMovies() {
        DBConnector.instance.getRecommendedMovies(callback: {
            movies in
            if (movies.count == 0) { // If there are no recommended movies, display similar ones instead.
                DBConnector.instance.getSimilarMovies(callback: {
                    similar in
                    self.movies = similar
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            } else {
                self.movies = movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedMovieCell", for: indexPath) as! RecommendedMovieCell
        let score = movies[indexPath.row]
        cell.posterImg = score.setPoster(image: cell.posterImg) // Set poster image.
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let score = movies[indexPath.row]
        AppDelegate.instance.sendToMovieController(movie: score,
                                                   navigationController: self.superview?.findViewController()?.navigationController,
                                                   storyboard: self.superview?.findViewController()?.storyboard)
    }
}


