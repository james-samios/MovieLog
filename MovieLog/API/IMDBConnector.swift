//
//  IMDBConnector.swift
//  MovieLog
//
//  Created by James Samios on 9/5/2022.
//

import Foundation

class IMDBConnector {
    
    static let instance = IMDBConnector() // Static reference of our API for access across the app.
    
    private let endpoint = "https://api.themoviedb.org/3/"
    
    private func get(query: String, callback: @escaping ([String: Any]) -> Void) {
        guard let url = URL(string: "\(endpoint)\(query)") else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMmUwMzQ0NGMyMzdjYjc3OWUyZGIwODQwN2QwOGU5ZSIsInN1YiI6IjYyN2EwYjliYTdlMzYzMDA5YzM1MDNkZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.U7KqW62oCJqZE_r7rwrW9E_Ca2OqHUfbfv8lcXHxov4", forHTTPHeaderField: "Authorization") // Authentication bearer token for connection with TheMovieDB's API.
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
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
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        callback(json)
//                        print("json");
//                        print(json)
                        
                    }
                } catch let error as NSError {
                    print("Unable to convert data to JSON. \(error)")
                }
            }
        })
        task.resume()
    }
    
    func searchForMovies(search: String) -> [Movie] {
        var movies: [Movie] = []
        get(query: "search/movies?query=\(search)", callback: {
            (data) in
            if let results = data["results"] as? [Data] {
                for encodedMovie in results {
                    if let movie = try? JSONDecoder().decode(Movie.self, from: encodedMovie) {
                        movies.append(movie)
                    }
                }
            }
        })
        return movies
    }
    
    func getPopularMovies() -> [Movie]{

        var popularMovies: [Movie] = []
         get(query: "/discover/movie?sort_by=popularity.desc", callback: {
            (data) in
            if let results = data["results"] as? [Data] {
                for encodedMovie in results {
                    if let movie = try? JSONDecoder().decode(Movie.self, from: encodedMovie) {
                        popularMovies.append(movie)
                        print("movie")
                        print(movie)
                    }
                }
            }
        })
        sleep(1);
        return popularMovies
    }
    
}
