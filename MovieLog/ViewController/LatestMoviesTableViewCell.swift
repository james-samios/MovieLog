//
//  HomeTableViewCell.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 11/5/2022.
//

import UIKit

class LatestMoviesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var movies: [Movie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Assign delegate and data source to this class.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Load the latest movies.
        DBConnector.instance.getLatestMovies(callback: {
            movies in
            // Set them to the local movies array.
            self.movies = movies
            DispatchQueue.main.async {
                // Reload the data on the main thread.
                self.collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestMovieCell", for: indexPath) as! LatestMovieCell
        guard movies.indices.contains(indexPath.row) else {
            // don't set the image to anything.
            return cell
        }
        let score = movies[indexPath.row]
        cell.posterImg = score.setPoster(image: cell.posterImg) // set the poster image.
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

