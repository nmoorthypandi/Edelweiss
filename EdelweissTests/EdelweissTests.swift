//
//  EdelweissTests.swift
//  EdelweissTests
//
//  Created by Aadithya on 26/01/22.
//

import XCTest
@testable import Edelweiss

class EdelweissTests: XCTestCase {
    let movieViewModel = MoviesViewModel(movie: TestMovies())
    let indexPath = IndexPath(row: 0, section: 0)
    func testGetMovieTitle() {
        let movieName = movieViewModel.getMovieName(indexPath)
        XCTAssertEqual(movieName, "")
    }
    
    func testGetMovieHeadLine() {
        let headLine = movieViewModel.movieHeadLine
        XCTAssertEqual(headLine, "")
    }
    
    func testGetMovieSummary() {
        let summary = movieViewModel.getMovieSummary(indexPath)
        XCTAssertEqual(summary, "")
    }
    
    func testGetMovieCount() {
        let count = movieViewModel.getMovieCount()
        XCTAssertEqual(count, 0)
    }
}

class TestMovies: MoviesViewModelProtocol {
    var movies: [Movies] = []
    
    func getMovies(_ completion: @escaping ([Movies]) -> Void) {
        completion([])
    }
}
