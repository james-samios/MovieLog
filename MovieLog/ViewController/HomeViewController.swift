//
//  HomeViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 11/5/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var latestMovies: UITableView!
    @IBOutlet var recommendedMovies: UITableView!
    
    let latestMoviesSource = LatestMovieSource()
    let recommendedMoviesSource = RecommendedMovieSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.latestMovies.dataSource = self.latestMoviesSource
        self.recommendedMovies.dataSource = self.recommendedMoviesSource
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

class RecommendedMovieSource: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedMoviesTableViewCell", for: indexPath) as? RecommendedMoviesTableViewCell else {fatalError("Unable to create table")}
        
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
    
    @IBOutlet var posterImg: UIImageView!
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedMoviesTableViewCell", for: indexPath)
        
        return cell
    }
    
    
}
