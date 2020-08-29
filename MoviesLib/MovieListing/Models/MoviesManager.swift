//
//  MovieManager.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 29/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import Foundation

struct MoviesManager {
    
    private let movies: [Movie] = {
        guard let jsonURL = Bundle.main.url(forResource: "movies", withExtension: "json") else {return []}
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let jsonDecoder = JSONDecoder()
            //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            //jsonDecoder.dateDecodingStrategy = .iso8601
            return try jsonDecoder.decode([Movie].self, from: jsonData)
        } catch {
            print(error)
        }
        return []
    }()
    
    var totalMovies: Int {
        movies.count
    }
    
    func getMoviesAt(_ indexPath: IndexPath) -> Movie {
        movies[indexPath.row]
    }
}
