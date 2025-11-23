//
//  Movie_Explorer_AppTests.swift
//  Movie Explorer AppTests
//
//  Created by Subramaniyan on 22/11/25.
//

import XCTest
import CoreData
@testable import Movie_Explorer_App

final class Movie_Explorer_AppTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var moviesViewModel: MoviesViewModel!
    var movieDetailViewModel: MovieDetailViewModel!
    
    override func setUpWithError() throws {
        coreDataManager = CoreDataManager()
        moviesViewModel = MoviesViewModel()
        movieDetailViewModel = MovieDetailViewModel()
    }

    override func tearDownWithError() throws {
        coreDataManager = nil
        moviesViewModel = nil
        movieDetailViewModel = nil
    }

    // MARK: - CoreData Tests
    func testAddToFavorites() throws {
        let movie = createSampleMovie()
        coreDataManager.addToFavorites(movie: movie, runtime: 120)
        
        XCTAssertTrue(coreDataManager.isFavorite(movieId: movie.id ?? 0))
    }
    
    func testRemoveFromFavorites() throws {
        let movie = createSampleMovie()
        coreDataManager.addToFavorites(movie: movie, runtime: 120)
        coreDataManager.removeFromFavorites(movieId: movie.id ?? 0)
        
        XCTAssertFalse(coreDataManager.isFavorite(movieId: movie.id ?? 0))
    }
    
    func testGetFavorites() throws {
        let movie1 = createSampleMovie(id: 1)
        let movie2 = createSampleMovie(id: 2)
        
        coreDataManager.addToFavorites(movie: movie1, runtime: 120)
        coreDataManager.addToFavorites(movie: movie2, runtime: 90)
        
        let favorites = coreDataManager.getFavorites()
        XCTAssertEqual(favorites.count, 2)
    }
    
    func testFavoriteToggle() throws {
        let movie = createSampleMovie()
        
        // Initially not favorite
        XCTAssertFalse(coreDataManager.isFavorite(movieId: movie.id ?? 0))
        
        // Add to favorites
        coreDataManager.addToFavorites(movie: movie, runtime: 120)
        XCTAssertTrue(coreDataManager.isFavorite(movieId: movie.id ?? 0))
        
        // Remove from favorites
        coreDataManager.removeFromFavorites(movieId: movie.id ?? 0)
        XCTAssertFalse(coreDataManager.isFavorite(movieId: movie.id ?? 0))
    }
    
    // MARK: - ViewModel Tests
    func testMoviesViewModelInitialization() throws {
        XCTAssertNotNil(moviesViewModel)
        XCTAssertEqual(moviesViewModel.movies.count, 0)
        XCTAssertEqual(moviesViewModel.searchResults.count, 0)
        XCTAssertFalse(moviesViewModel.isLoading)
        XCTAssertFalse(moviesViewModel.isSearching)
    }
    
    func testMovieDetailViewModelInitialization() throws {
        XCTAssertNotNil(movieDetailViewModel)
        XCTAssertNil(movieDetailViewModel.movieDetails)
        XCTAssertEqual(movieDetailViewModel.trailers.count, 0)
        XCTAssertFalse(movieDetailViewModel.isLoading)
    }
    
    func testSearchTextDebounce() throws {
        let expectation = XCTestExpectation(description: "Search debounce")
        
        moviesViewModel.searchText = "test"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Model Tests
    func testMovieModelDecoding() throws {
        let json = """
        {
            "id": 123,
            "title": "Test Movie",
            "overview": "Test overview",
            "vote_average": 8.5,
            "poster_path": "/test.jpg",
            "release_date": "2023-01-01"
        }
        """
        
        let data = json.data(using: .utf8)!
        let movie = try JSONDecoder().decode(Result.self, from: data)
        
        XCTAssertEqual(movie.id, 123)
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertEqual(movie.overview, "Test overview")
        XCTAssertEqual(movie.voteAverage, 8.5)
        XCTAssertEqual(movie.posterPath, "/test.jpg")
        XCTAssertEqual(movie.releaseDate, "2023-01-01")
    }
    
    func testMovieDetailsModelDecoding() throws {
        let json = """
        {
            "id": 123,
            "title": "Test Movie",
            "runtime": 120,
            "genres": [{"id": 1, "name": "Action"}],
            "vote_average": 8.5
        }
        """
        
        let data = json.data(using: .utf8)!
        let movieDetails = try JSONDecoder().decode(MovieListDetails.self, from: data)
        
        XCTAssertEqual(movieDetails.id, 123)
        XCTAssertEqual(movieDetails.title, "Test Movie")
        XCTAssertEqual(movieDetails.runtime, 120)
        XCTAssertEqual(movieDetails.genres?.first?.name, "Action")
        XCTAssertEqual(movieDetails.voteAverage, 8.5)
    }
    
    // MARK: - Extension Tests
    func testRatingFormatting() throws {
        let rating = 8.567
        XCTAssertEqual(rating.formatRating(), "8.6")
    }
    
    func testRuntimeFormatting() throws {
        let runtime120 = 120
        XCTAssertEqual(runtime120.formatRuntime(), "2h 0m")
        
        let runtime95 = 95
        XCTAssertEqual(runtime95.formatRuntime(), "1h 35m")
        
        let runtime45 = 45
        XCTAssertEqual(runtime45.formatRuntime(), "45m")
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
