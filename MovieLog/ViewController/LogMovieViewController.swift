//
//  SavedViewController.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit


class LogMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var logTableView: UITableView!
    
    //TO BE REPLACED WITH IMDB DATA
    let logData = ["first", "second", "third", "fourth"]
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        logTableView.delegate = self
        logTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = logData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell") as! LogTableViewCell
        
        cell.setLogCell(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "seenMovieController") as? seenMovieController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        
    }
    
}

