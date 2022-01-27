//
//  MovieDetailsViewController.swift
//  Edelweiss
//
//  Created by Aadithya on 27/01/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieHeadLineLabel: UILabel!
    @IBOutlet weak var movieDescLabel: UILabel!
    var movieViewModel: MoviesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        movieImageView.image = movieViewModel.getMovieImage(movieViewModel.selectedIndexPath)
        movieNameLabel.text = movieViewModel.getMovieName(movieViewModel.selectedIndexPath)
        movieHeadLineLabel.text = movieViewModel.movieHeadLine
        movieDescLabel.text = movieViewModel.getMovieSummary(movieViewModel.selectedIndexPath)
    }
}
