//
//  ViewController.swift
//  Edelweiss
//
//  Created by Aadithya on 26/01/22.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView! {
        didSet {
            moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        }
    }
    
    var movieViewModel: MoviesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "Movies"
        movieViewModel = MoviesViewModel(movie: MovieService())
        movieViewModel?.getMovies { _ in
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel?.getMovieCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        movieCell.movieImageView.image = movieViewModel?.getMovieImage(indexPath)
        movieCell.movieTitleLabel.text = movieViewModel?.getMovieName(indexPath)
        movieCell.movieSummaryLabel.text = movieViewModel?.getMovieSummary(indexPath)
        return movieCell
    }
}

