//
//  ViewModelTests.swift
//  Movie Explorer AppTests
//
//  Created by Subramaniyan on 22/11/25.
//

import XCTest
import Combine
@testable import Movie_Explorer_App

final class ViewModelTests: XCTestCase {
    var moviesViewModel: MoviesViewModel!
    var movieDetailViewModel: MovieDetailViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        moviesViewModel = MoviesViewModel()
        movieDetailViewModel = MovieDetailViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        moviesViewModel = nil
        movieDetailViewModel = nil
        cancellables = nil
    }
    
    // MARK: - MoviesViewModel Tests
    func testMoviesViewModelFavoriteToggle() throws {
        let movie = createSampleMovie()
        
        // Initially not favorite
        XCTAssertFalse(moviesViewModel.isFavorite(movieId: movie.id ?? 0))
        
        // Toggle to favorite
        moviesViewModel.toggleFavorite(movie: movie, runtime: 120)
        XCTAssertTrue(moviesViewModel.isFavorite(movieId: movie.id ?? 0))
        
        // Toggle back to not favorite
        moviesViewModel.toggleFavorite(movie: movie, runtime: 120)
        XCTAssertFalse(moviesViewModel.isFavorite(movieId: movie.id ?? 0))
    }
    
    func testMoviesViewModelImageURL() throws {
        let posterPath = "/test.jpg"
        let imageURL = moviesViewModel.getImageURL(path: posterPath)
        
        XCTAssertNotNil(imageURL)
        XCTAssertTrue(imageURL?.contains(posterPath) == true)
    }
    
    func testMoviesViewModelRuntimeRetrieval() throws {
        let movieId = 123
        let runtime = moviesViewModel.getRuntime(for: movieId)
        
        // Initially should be nil as no runtime data is loaded
        XCTAssertNil(runtime)
    }
    
    func testSearchTextBinding() throws {
        let expectation = XCTestExpectation(description: "Search text update")
        
        moviesViewModel.$searchText
            .dropFirst()
            .sink { searchText in
                XCTAssertEqual(searchText, "test movie")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        moviesViewModel.searchText = "test movie"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - MovieDetailViewModel Tests
    func testMovieDetailViewModelInitialState() throws {
        XCTAssertNil(movieDetailViewModel.movieDetails)
        XCTAssertEqual(movieDetailViewModel.trailers.count, 0)
        XCTAssertFalse(movieDetailViewModel.isLoading)
        XCTAssertNil(movieDetailViewModel.errorMessage)
    }
    
    func testMovieDetailViewModelFavoriteToggle() throws {
        let movie = createSampleMovie()
        
        // Initially not favorite
        XCTAssertFalse(movieDetailViewModel.isFavorite(movieId: movie.id ?? 0))
        
        // Toggle to favorite
        movieDetailViewModel.toggleFavorite(movie: movie, runtime: 120)
        XCTAssertTrue(movieDetailViewModel.isFavorite(movieId: movie.id ?? 0))
    }
    
    func testMovieDetailViewModelImageURL() throws {
        let backdropPath = "/backdrop.jpg"
        let imageURL = movieDetailViewModel.getImageURL(path: backdropPath)
        
        XCTAssertNotNil(imageURL)
        XCTAssertTrue(imageURL?.contains(backdropPath) == true)
    }
    
    // MARK: - Helper Methods
    private func createSampleMovie(id: Int = 123) -> Result {
        return Result(
            adult: false,
            backdropPath: "/backdrop.jpg",
            genreIDS: [28, 12],
            id: id,
            originalLanguage: .en,
            originalTitle: "Sample Movie",
            overview: "This is a sample movie for testing.",
            popularity: 100.0,
            posterPath: "/poster.jpg",
            releaseDate: "2023-01-01",
            title: "Sample Movie",
            video: false,
            voteAverage: 8.5,
            voteCount: 1000
        )
    }
}
