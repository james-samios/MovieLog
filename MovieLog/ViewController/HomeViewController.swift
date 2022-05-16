//
//  HomeViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 11/5/2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ARRAY: ")
        print(IMDBConnector.instance.getPopularMovies())
//        print("IRON: ")
//       print(IMDBConnector.instance.searchForMovies(search: "Iron"));
        // Do any additional setup after loading the view.
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {fatalError("Unable to create table")}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}
