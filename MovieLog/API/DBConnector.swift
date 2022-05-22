//
//  IMDBConnector.swift
//  MovieLog
//
//  Created by James Samios on 9/5/2022.
//

import Foundation
import SwiftyJSON
import SwiftUI

class DBConnector {
    
    static let instance = DBConnector() // Static reference of our API for access across the app.
    
    private let endpoint = "https://api.themoviedb.org/3/" // The endpoint of our Movie Database API.
    
    /// Get JSON data from the movie database.
    /// - Parameters:
    ///     - query: The end-point to get data from.
    ///     - callback: The async callback lambda that returns a JSON object.
    private func get(query: String, callback: @escaping (JSON?) -> Void) {
        let finalUrl = "\(endpoint)\(query)"
        guard let url = URL(string: finalUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { fatalError() } // encode the URL for spaces, etc.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMmUwMzQ0NGMyMzdjYjc3OWUyZGIwODQwN2QwOGU5ZSIsInN1YiI6IjYyN2EwYjliYTdlMzYzMDA5YzM1MDNkZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.U7KqW62oCJqZE_r7rwrW9E_Ca2OqHUfbfv8lcXHxov4", forHTTPHeaderField: "Authorization") // Authentication bearer token for connection with TheMovieDB's API.
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Unable to fetch data: \(error)") // this can happen if the user has no internet connection, etc. 
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                      print("Invalid response code received: \(String(describing: response))")
                return
            }
            
            if let data = data {
                if let json = try? JSON(data: data) {
                    callback(json)
                } else {
                    callback(nil)
                }
            }
          }).resume()
    }
    
    /// Get Movies by Endpoint
    /// - Parameters:
    ///     - query: The endpoint query to search the API with.
    ///     - callback: The async callback lambda containing the movies array.
    func getMovies(query: String, callback: @escaping ([Movie]) -> Void) {
        get(query: query) { json in
            if (json == nil) {
                callback([])
            } else {
                var movies: [Movie] = []
                for encodedMovie in json!["results"].arrayValue {
                    if let movie = try? JSONDecoder().decode(Movie.self, from: encodedMovie.rawData()) { // decode from JSON --> Movie
                        movies.append(movie)
                    }
                }
                callback(movies)
            }
        }
    }
    
    
    /// Get Movie Genres
    func getGenres(callback: @escaping ([Int: String]) -> Void) {
        get(query: "genre/movie/list") { json in
            var genres = [Int: String]()
            if (json == nil) {
                callback(genres)
            } else {
                for genre in json!["genres"].arrayValue {
                    genres.updateValue(genre["name"].stringValue, forKey: genre["id"].intValue)
                }
                callback(genres)
            }
        }
    }
    
    /// Search for Movies by Name
    /// - Parameters:
    ///     - search: The string value to search the movies with.
    ///     - callback: The async callback lamda that holds the movies as an array.
    func searchForMovies(search: String, callback: @escaping ([Movie]) -> Void) {
        getMovies(query: "search/movie?query=\(search)", callback: {
            movies in
            callback(movies)
        })
    }
    
    /// Get Popular Movies
    func getPopularMovies(callback: @escaping ([Movie]) -> Void) {
        getMovies(query: "discover/movie?sort_by=popularity.desc", callback: {
           movies in
           callback(movies)
       })
    }
    
    /// Get Latest Movies
    func getLatestMovies(callback: @escaping ([Movie]) -> Void) {
        getMovies(query: "movie/now_playing", callback: {
            movies in
            callback(movies)
        })
    }
    
    /// Get Recommended Movies
    /// This uses the last value from the log book to use.
    func getRecommendedMovies(callback: @escaping ([Movie]) -> Void) {
        if (!getLoggedMovies().indices.contains(0)) { // If there is nothing in the logbook.
            // Add the sample movie to the logged movies.
            logNewMovie(newMovie: LoggedMovie(movie: AppDelegate.instance.sampleMovie!, summary: "I really enjoyed this movie. It was great.", rating: "8"))
        }
        let movie = getLoggedMovies()[0]
        getMovies(query: "movie/\(movie.movie.id)/recommendations", callback: {
            movies in
            callback(movies)
        })
    }
    
    /// Get Similar Movies
    /// This is run when there are no recommended movies for the home page.
    func getSimilarMovies(callback: @escaping ([Movie]) -> Void) {
        let movie = getLoggedMovies()[0]
        getMovies(query: "movie/\(movie.movie.id)/similar", callback: {
            movies in
            callback(movies)
        })
    }
    
    //======Favourite Movies=======\\
    
    /// Returns a list of the users favourited movies from USER DEFAULTS
    func getFavouriteMovies() -> [Movie] {
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: "favourites") as? Data {
            if let array = try? PropertyListDecoder().decode(Array<Movie>.self, from: savedArrayData) {
                return array.reversed()
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    /// Toggles a movie as being a favourite or not.
    func toggleFavourite(mode: Bool, movie: Movie){
        // Call this function from the favourite button and pass in a bool value to determine the state of the button
        if !mode {
            addFavouriteMovie(newMovie: movie)
        }
        else {
            removeFavouriteMovie(newMovie: movie)
        }
    }
    
    /// Adds a favourited movie to the USER DEFAULTS favourites list
    func addFavouriteMovie(newMovie: Movie) {
        let defaults = UserDefaults.standard
        var newList = getFavouriteMovies()
        for movie in newList {
            if newMovie.id == movie.id {
                //Return if that movie is already favourited
                return;
            }
        }
        
        //Add the movie to the favourites list
        newList.append(newMovie)
        
        defaults.removeObject(forKey: "favourites")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "favourites")
    }
    
    /// Removes a favourited movie from the USER DEFAULTS favourites list
    func removeFavouriteMovie(newMovie: Movie) {
        let defaults = UserDefaults.standard
        var newList = getFavouriteMovies()
        for (index, movie) in newList.enumerated() {
            if newMovie.id == movie.id {
                newList.remove(at: index)
                //Remove the movie from the listdi
            }
        }
        //Reset defaults
        defaults.removeObject(forKey: "favourites")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "favourites")
    }
    
    /// Checks if a movie is favourited
    func isMovieFavourited(movie: Movie) -> Bool {
        var favourited = false
        for favouritedMovie in getFavouriteMovies() {
            if favouritedMovie.id == movie.id {
                favourited = true
                break
            }
        }
        return favourited
    }
    
    //======Logged Movies=======\\
    
    /// Returns all of the user's logged movies.
    func getLoggedMovies() -> [LoggedMovie]{
        // A USER DEFAULTS array of the LoggedMovie struct which contains a review, score and movie. Holds onto the movies a user has seen/logged
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: "logged") as? Data {
            if let array = try? PropertyListDecoder().decode(Array<LoggedMovie>.self, from: savedArrayData) {
                return array.reversed()
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    /// Adds a new movie to the USER DEFAULTS logged array
    func logNewMovie(newMovie: LoggedMovie){
        let defaults = UserDefaults.standard
        var newList = getLoggedMovies()
        for (index, movie) in newList.enumerated() {
            if newMovie.movie.id == movie.movie.id {
                newList.remove(at: index)
            }
        }
        
        let watchList = getWatchList()
        for movie in watchList {
            //If a movie is in the watchlist and it is logged, remove it from the watchlist (if it is logged, you have seen it)
            if newMovie.movie.id == movie.id {
                removeFromWatchList(newMovie: newMovie.movie)
            }
        }
        newList.append(newMovie)
        
        defaults.removeObject(forKey: "logged")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "logged")
    }
    
    /// Removes a new movie to the USER DEFAULTS logged array
    func removeLoggedMovie(newMovie: LoggedMovie){
        let defaults = UserDefaults.standard
        var newList = getLoggedMovies()
        for (index, movie) in newList.enumerated() {
            if newMovie.movie.id == movie.movie.id {
                newList.remove(at: index)
            }
        }
        //Reset defaults
        defaults.removeObject(forKey: "favourites")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "favourites")
    }
    
    /// Checks if a movie is in the LOGGED LIST
    func isMovieLogged(movie: Movie) -> Bool {
        var logged = false
        for loggedMovie in getLoggedMovies() {
            if loggedMovie.movie.id == movie.id {
                logged = true
                break
            }
        }
        return logged
    }
    
    /// Returns a LoggedMovie from a Movie object, if it has been logged.
    func getLoggedMovie(movie: Movie) -> LoggedMovie? {
        var loggedMovie: LoggedMovie? = nil
        for logMovie in getLoggedMovies() {
            if (logMovie.movie.id == movie.id) {
                loggedMovie = logMovie
                break
            }
        }
        return loggedMovie
    }
    
    //======Watch List=======\\
    
    /// Returns the movies in the USER DEFAULTS watchList
    func getWatchList() -> [Movie] {
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: "watchList") as? Data {
            if let array = try? PropertyListDecoder().decode(Array<Movie>.self, from: savedArrayData) {
                return array.reversed()
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    /// Toggles a movie as being in the watch list or not.
    func toggleWatchList(mode: Bool, movie: Movie) {
        //Call this function from the favourite button and pass in a bool value to determine the state of the button
        if !mode {
            addToWatchList(newMovie: movie)
        }
        else {
            removeFromWatchList(newMovie: movie)
        }
    }
    
    /// Adds a movie to the watch list
    func addToWatchList(newMovie: Movie) {
        let defaults = UserDefaults.standard
        var newList = getWatchList()
        for movie in newList {
            if newMovie.id == movie.id {
                return;
            }
        }
        
        //Add the movie to the watch list
        newList.append(newMovie)
        
        defaults.removeObject(forKey: "watchList")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "watchList")
    }
    
    /// Removes a movie from the watch list.
    func removeFromWatchList(newMovie: Movie){
        let defaults = UserDefaults.standard
        var newList = getWatchList()
        for (index, movie) in newList.enumerated() {
            if(newMovie.id == movie.id){
                newList.remove(at: index)
            }
        }
        //Reset defaults
        defaults.removeObject(forKey: "watchList")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "watchList")
    }
    
    /// Checks if a movie is in the watch list
    func isMovieInWatchlist(movie: Movie) -> Bool {
        var watched = false
        for watchedMovie in getWatchList() {
            if watchedMovie.id == movie.id {
                watched = true
                break
            }
        }
        return watched
    }
}
