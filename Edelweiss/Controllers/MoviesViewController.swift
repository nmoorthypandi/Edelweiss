//
//  ViewController.swift
//  Edelweiss
//
//  Created by Aadithya on 26/01/22.
//

import UIKit

class MoviesViewController: UIViewController {

    let movieTableCellIdentifier = "MovieTableViewCell"
    @IBOutlet weak var moviesTableView: UITableView! {
        didSet {
            moviesTableView.register(UINib(nibName: movieTableCellIdentifier, bundle: nil), forCellReuseIdentifier: movieTableCellIdentifier)
        }
    }
    
    var movieViewModel: MoviesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Movies"
        movieViewModel = MoviesViewModel(movie: MovieService())
        getMovieList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedIndexPath = moviesTableView.indexPathForSelectedRow {
            self.moviesTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func getMovieList() {
        movieViewModel.getMovies { _ in
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
    }
    
    func navigateToMovieDetailsVC() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let movieDetailsViewController =
                 storyBoard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            movieDetailsViewController.movieViewModel = movieViewModel
            self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.getMovieCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        movieCell.movieImageView.image = movieViewModel.getMovieImage(indexPath)
        movieCell.movieTitleLabel.text = movieViewModel.getMovieName(indexPath)
        movieCell.movieSummaryLabel.text = movieViewModel.getMovieSummary(indexPath)
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieViewModel.selectedIndexPath = indexPath
        navigateToMovieDetailsVC()
    }
}

