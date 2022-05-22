//
//  AppDelegate.swift
//  MovieLog
//
//  Created by James Samios on 3/5/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Shared instance of the AppDelegate for obtaining Genres and the sample Movie object.
    static let instance = UIApplication.shared.delegate as! AppDelegate
    
    var genres = [Int: String]()
    var sampleMovie: Movie? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Load our genres locally so we don't have to keep asking the database for every single movie.
        DBConnector.instance.getGenres(callback: { genres in
            self.genres = genres
        })
        
        // Add in the sample movie here as the placeholder for a fresh launch of the app.
        self.sampleMovie = Movie(id: 68721, title: "Iron Man 3", overview: "When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution.", vote_average: 6.9, vote_count: 19440, poster_path: "/qhPtAc1TKbMPqNvcdXSOn9Bn7hZ.jpg", release_date: "2013-04-18", original_language: "en", genre_ids: [28, 12, 878])
        return true
    }
    
    /// Gets the plaintext name for a Genre by its given ID.
    /// - Parameters:
    ///     - id: The ID of the genre to retrieve
    /// - Returns: The genre's plaintext value
    func getGenreNameById(id: Int) -> String {
        return genres[id] ?? "N/A"
    }
    
    /// Helper function to send the user to a movie controller based on the user's log book.
    /// - Parameters;
    ///     - movie:  The movie to be viewed.
    ///     - navigationController: The navigation controller of the current view
    ///     - storyboard: The storyboard class from the current view.
    func sendToMovieController(movie: Movie, navigationController: UINavigationController?, storyboard: UIStoryboard?) {
        if (DBConnector.instance.isMovieLogged(movie: movie)) { // Seen Controller
            let seen = storyboard?.instantiateViewController(withIdentifier: "SeenMovieController") as! SeenMovieController
            seen.setMovie(movie: movie)
            navigationController?.pushViewController(seen, animated: true)
        } else { // Edit Controller
            let edit = storyboard?.instantiateViewController(withIdentifier: "EditMovieController") as! EditMovieController
            edit.setMovie(movie: movie)
            navigationController?.pushViewController(edit, animated: true)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension UIView {
    /// Helper function to get the UIViewController from the current UIView.
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
