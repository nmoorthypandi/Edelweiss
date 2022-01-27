//
//  ApiService.swift
//  Edelweiss
//
//  Created by Aadithya on 27/01/22.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noData
    case invalidJSONFormat
}

protocol MovieApiServiceProtocol {
    func getMovies(_ completion: @escaping(Result<MoviesDataModel, NetworkError>) -> Void)
}

class ApiService {
    let movieApiServiceProtocol: MovieApiServiceProtocol
    init(movieApiServiceProtocol: MovieApiServiceProtocol) {
        self.movieApiServiceProtocol = movieApiServiceProtocol
    }
    
    func getMovies(_ completion: @escaping (Result<MoviesDataModel, NetworkError>) -> Void) {
        movieApiServiceProtocol.getMovies(completion)
    }
}

class MovieApiService: MovieApiServiceProtocol {
    let baseURL = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=godfather&api-key=U3MmwD0tMDhl8HcqRLWJaSF6XiOE8oEJ"
    func getMovies(_ completion: @escaping (Result<MoviesDataModel, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, responseError in
            guard responseError == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.noData))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode(MoviesDataModel.self, from: data)
                completion(.success(users))
            } catch let err {
                print(err.localizedDescription)
                completion(.failure(.invalidJSONFormat))
            }
            
        }.resume()
    }
}
