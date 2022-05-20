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
    
    private let endpoint = "https://api.themoviedb.org/3/"
    
    private func get(query: String, callback: @escaping (JSON?) -> Void) {
        let finalUrl = "\(endpoint)\(query)"
        guard let url = URL(string: finalUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { fatalError() }
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
    
    func getMovies(query: String, callback: @escaping ([Movie]) -> Void) {
        get(query: query) { json in
            if (json == nil) {
                callback([])
            } else {
                var movies: [Movie] = []
                for encodedMovie in json!["results"].arrayValue {
                    if let movie = try? JSONDecoder().decode(Movie.self, from: encodedMovie.rawData()) {
                        movies.append(movie)
                    }
                }
                callback(movies)
            }
        }
    }
    
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
    
    func searchForMovies(search: String, callback: @escaping ([Movie]) -> Void) {
        getMovies(query: "search/movie?query=\(search)", callback: {
            movies in
            callback(movies)
        })
    }
    
    func getPopularMovies(callback: @escaping ([Movie]) -> Void) {
        getMovies(query: "discover/movie?sort_by=popularity.desc", callback: {
           movies in
           callback(movies)
       })
    }
    
    func getLatestMovies(callback: @escaping ([Movie]) -> Void) {
        getMovies(query: "movie/now_playing", callback: {
            movies in
            callback(movies)
        })
    }
    
    func getRecommendedMovies(callback: @escaping ([Movie]) -> Void) {
        if (!getLoggedMovies().indices.contains(0)) {
            logNewMovie(newMovie: LoggedMovie(movie: AppDelegate.instance.sampleMovie!, summary: "I really enjoyed this movie. It was great.", rating: "8"))
        }
        let movie = getLoggedMovies()[0]
        getMovies(query: "movie/\(movie.movie.id)/recommendations", callback: {
            movies in
            callback(movies)
        })
    }
    
    func getSimilarMovies(callback: @escaping ([Movie]) -> Void) {
        let movie = getLoggedMovies()[0]
        getMovies(query: "movie/\(movie.movie.id)/similar", callback: {
            movies in
            callback(movies)
        })
    }
    
    //======Favourite Movies=======
    func getFavouriteMovies() -> [Movie]{
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: "favourites") as? Data{
            if let array = try? PropertyListDecoder().decode(Array<Movie>.self, from: savedArrayData) {
                return array.reversed()
            } else {
                return []
            }
        }else{
            return []
        }
    }
    
    func toggleFavourite(mode: Bool, movie: Movie){
        //Call this function from the favourite button and pass in a bool value to determine the state of the button
        if !mode {
            addFavouriteMovie(newMovie: movie)
        }
        else {
            removeFavouriteMovie(newMovie: movie)
        }
    }
    
    func addFavouriteMovie(newMovie: Movie){
        let defaults = UserDefaults.standard
        var newList = getFavouriteMovies()
        for movie in newList {
            if(newMovie.id == movie.id){
                //Return if that movie is already favourited
                return;
            }
        }
        
        //Add the movie to the favourites list
        newList.append(newMovie)
        
        defaults.removeObject(forKey: "favourites")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "favourites")
    }
    
    func removeFavouriteMovie(newMovie: Movie){
        let defaults = UserDefaults.standard
        var newList = getFavouriteMovies()
        for (index, movie) in newList.enumerated() {
            if(newMovie.id == movie.id){
                newList.remove(at: index)
                //Remove the movie from the listdi
            }
        }
        //Reset defaults
        defaults.removeObject(forKey: "favourites")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "favourites")
    }
    
    func isMovieFavourited(movie: Movie) -> Bool {
        var favourited = false
        for favouritedMovie in getFavouriteMovies() {
            if (favouritedMovie.id == movie.id) {
                favourited = true
                break
            }
        }
        return favourited
    }
    
    //======Logged Movies=======
    func getLoggedMovies() -> [LoggedMovie]{
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: "logged") as? Data{
            if let array = try? PropertyListDecoder().decode(Array<LoggedMovie>.self, from: savedArrayData) {
                return array.reversed()
            } else {
                return []
            }
        }else{
            return []
        }
    }
    
    func logNewMovie(newMovie: LoggedMovie){
        let defaults = UserDefaults.standard
        var newList = getLoggedMovies()
        for (index, movie) in newList.enumerated() {
            if(newMovie.movie.id == movie.movie.id){
                newList.remove(at: index)
            }
        }
        
        let watchList = getWatchList()
        for movie in watchList {
            if newMovie.movie.id == movie.id {
                removeFromWatchList(newMovie: newMovie.movie)
            }
        }
        newList.append(newMovie)
        
        defaults.removeObject(forKey: "logged")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "logged")
    }
    
    func removeLoggedMovie(newMovie: LoggedMovie){
        let defaults = UserDefaults.standard
        var newList = getLoggedMovies()
        for (index, movie) in newList.enumerated() {
            if(newMovie.movie.id == movie.movie.id){
                newList.remove(at: index)
            }
        }
        //Reset defaults
        defaults.removeObject(forKey: "favourites")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "favourites")
    }
    
    func isMovieLogged(movie: Movie) -> Bool {
        var logged = false
        for loggedMovie in getLoggedMovies() {
            if (loggedMovie.movie.id == movie.id) {
                logged = true
                break
            }
        }
        return logged
    }
    
    //======Watch List=======
    func getWatchList() -> [Movie]{
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: "watchList") as? Data{
            if let array = try? PropertyListDecoder().decode(Array<Movie>.self, from: savedArrayData) {
                return array
            } else {
                return []
            }
        }else{
            return []
        }
    }
    
    
    func toggleWatchList(mode: Bool, movie: Movie){
        //Call this function from the favourite button and pass in a bool value to determine the state of the button
        if !mode {
            addToWatchList(newMovie: movie)
        }
        else {
            removeFromWatchList(newMovie: movie)
        }
    }
    
    func addToWatchList(newMovie: Movie){
        let defaults = UserDefaults.standard
        var newList = getWatchList()
        for movie in newList {
            if(newMovie.id == movie.id){
                return;
            }
        }
        
        //Add the movie to the watch list
        newList.append(newMovie)
        
        defaults.removeObject(forKey: "watchList")
        defaults.set(try? PropertyListEncoder().encode(newList), forKey: "watchList")
    }
    
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
    
    func isMovieInWatchlist(movie: Movie) -> Bool {
        var watched = false
        for watchedMovie in getWatchList() {
            if (watchedMovie.id == movie.id) {
                watched = true
                break
            }
        }
        return watched
    }
}

struct LoggedMovie: Codable {
    var movie: Movie
    var summary: String
    var rating: String
}
