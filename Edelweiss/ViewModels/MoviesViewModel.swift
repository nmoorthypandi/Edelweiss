//
//  MoviesViewModel.swift
//  Edelweiss
//
//  Created by Aadithya on 27/01/22.
//

import Foundation
import UIKit

protocol MoviesViewModelProtocol {
    var movies: [Movies] { get set }
    func getMovies(_ completion: @escaping([Movies]) -> Void)
}

class MoviesViewModel {
    var movie: MoviesViewModelProtocol
    var selectedIndexPath: IndexPath!
    init(movie: MoviesViewModelProtocol) {
        self.movie = movie
    }
    
    var movieHeadLine: String {
        guard !movie.movies.isEmpty else { return "" }
        return movie.movies[selectedIndexPath.row].headline
    }
    func getMovies(_ completion: @escaping([Movies]) -> Void) {
        movie.getMovies { movies in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                _ = self?.movie.movies.enumerated().map { [weak self] (index, item) in
                    self?.downloadMovieImage(index)
                }
                self?.movie.movies.sort {
                    return $0.displayTitle < $1.displayTitle
                }
                completion(movies)
            }
        }
    }
    
    func getMovieCount() -> Int {
        return movie.movies.count
    }
    
    func downloadMovieImage(_ index: Int) {
        guard !movie.movies.isEmpty else { return }
        guard let url = URL(string: movie.movies[index].multimedia?.src ?? "") else {
            return
        }
        self.movie.movies[index].multimedia?.image = try? Data(contentsOf: url)
    }
    
    func getMovieImage(_ indexPath: IndexPath) -> UIImage {
        guard let movieImage = UIImage(named: "placeholder-img") else {
            return UIImage()
        }
        guard !movie.movies.isEmpty else { return movieImage }
        guard let data = movie.movies[indexPath.row].multimedia?.image else {
            return movieImage
        }
        return UIImage(data: data) ?? movieImage
    }
    
    func getMovieName(_ indexPath: IndexPath) -> String {
        guard !movie.movies.isEmpty else { return "" }
        return movie.movies[indexPath.row].displayTitle
    }
    
    func getMovieSummary(_ indexPath: IndexPath) -> String {
        guard !movie.movies.isEmpty else { return "" }
        guard !movie.movies[indexPath.row].summaryShort.isEmpty else { return "--" }
        return movie.movies[indexPath.row].summaryShort
    }
}

class MovieService: MoviesViewModelProtocol {
    var movies: [Movies] = []
    var movieApiService = MovieApiService()
    var apiServie: ApiService
    init() {
        apiServie = ApiService(movieApiServiceProtocol: movieApiService)
    }
    func getMovies(_ completion: @escaping ([Movies]) -> Void) {
        apiServie.getMovies { [weak self] result in
            switch(result) {
            case .success(let movieData):
                self?.movies = movieData.results
                completion(self?.movies ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
}
