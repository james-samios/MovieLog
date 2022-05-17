//
//  HomeTableViewCell.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 11/5/2022.
//

import UIKit
import Kingfisher

class LatestMoviesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    var movies: [Movie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        DBConnector.instance.getLatestMovies(callback: {
            movies in
            self.movies = movies
            DispatchQueue.main.async {
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
        
        
        let posterView = cell.posterImg!
        guard movies.indices.contains(indexPath.row) else {
            posterView.kf.indicatorType = .activity
            cell.posterImg = posterView
            return cell
        }
        let score = movies[indexPath.row]
        
        
        // Load the image. This can also retrieve it from cache.
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
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.posterImg = posterView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 400)
    }
}

