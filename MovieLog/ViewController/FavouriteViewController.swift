//
//  File.swift
//  OtherMovie
//
//  Created by Alexandra Streeton on 10/5/2022.
//

import Foundation
import UIKit

class favouriteCell: UITableViewCell {
    
}


class FavouriteViewController: UIViewController {
   
    @IBOutlet weak var favouriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
    }


}



extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as? favouriteCell  else {
            fatalError("unable to produce favourite list")
        }
          
        return cell
        
    }
    
    
    
}

