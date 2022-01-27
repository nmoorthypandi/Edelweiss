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
    init(movie: MoviesViewModelProtocol) {
        self.movie = movie
    }
    
    func getMovies(_ completion: @escaping([Movies]) -> Void) {
        movie.getMovies { movies in
            self.movie.movies.enumerated().map { [weak self] (index, item) in
                self?.downloadMovieImage(index)
            }
            completion(movies)
        }
    }
    
    func getMovieCount() -> Int {
        return movie.movies.count
    }
    
    func downloadMovieImage(_ index: Int) {
        guard let url = URL(string: movie.movies[index].multimedia?.src ?? "") else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.movie.movies[index].multimedia?.image = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //image = UIImage(data: data!)
        }
    }
    
    func getMovieImage(_ indexPath: IndexPath) -> UIImage {
        guard let movieImage = UIImage(named: "placeholder-img") else {
            return UIImage()
        }
        guard let data = movie.movies[indexPath.row].multimedia?.image else {
            return movieImage
        }
        return UIImage(data: data) ?? movieImage
    }
    
    func getMovieName(_ indexPath: IndexPath) -> String {
        return movie.movies[indexPath.row].displayTitle
    }
    
    func getMovieSummary(_ indexPath: IndexPath) -> String {
        guard !movie.movies[indexPath.row].summaryShort.isEmpty else { return "--" }
        return movie.movies[indexPath.row].summaryShort
    }
}

class MovieService: MoviesViewModelProtocol {
    var movies: [Movies] = []
    func getMovies(_ completion: @escaping ([Movies]) -> Void) {
        ApiService().getMovies { result in
            switch(result) {
            case .success(let movieData):
                self.movies = movieData.results
                completion(self.movies)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
