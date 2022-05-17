//
//  HomeViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 11/5/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var latestMovies: UITableView!
   
    
    let latestMoviesSource = LatestMovieSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.latestMovies.dataSource = self.latestMoviesSource
    }
      

}



class LatestMovieSource: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LatestMoviesTableViewCell", for: indexPath) as? LatestMoviesTableViewCell else {fatalError("Unable to create table")}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}

class LatestMovieCell: UICollectionViewCell {
    
    @IBOutlet var posterImg: UIImageView!
    
}

class RecommendedMovieCell: UICollectionViewCell {
    
}
