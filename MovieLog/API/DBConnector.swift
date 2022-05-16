//
//  IMDBConnector.swift
//  MovieLog
//
//  Created by James Samios on 9/5/2022.
//

import Foundation
import SwiftyJSON

class DBConnector {
    
    static let instance = DBConnector() // Static reference of our API for access across the app.
    
    private let endpoint = "https://api.themoviedb.org/4/"
    
    private func get(query: String, callback: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "\(endpoint)\(query)") else { fatalError() }
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
                    var movies: [Movie] = []
                    for encodedMovie in json["results"].arrayValue {
                        if let movie = try? JSONDecoder().decode(Movie.self, from: encodedMovie.rawData()) {
                            movies.append(movie)
                        }
                    }
                    callback(movies)
                } else {
                    callback([])
                }
            }
          }).resume()
    }
    
    
    
    func searchForMovies(search: String, callback: @escaping ([Movie]) -> Void) {
        get(query: "search/movie?query=\(search)", callback: {
            movies in
            callback(movies)
        })
    }
    
    func getPopularMovies(callback: @escaping ([Movie]) -> Void) {
        get(query: "discover/movie?sort_by=popularity.desc", callback: {
           movies in
           callback(movies)
       })
    }
    
}
