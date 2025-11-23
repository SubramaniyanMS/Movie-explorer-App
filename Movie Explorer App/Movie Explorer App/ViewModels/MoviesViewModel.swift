//
//  MoviesViewModel.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Result] = []
    @Published var searchResults: [Result] = []
    @Published var movieRuntimes: [Int: Int] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var isSearching = false
    @Published var showToast = false
    @Published var toastMessage = ""
    
    private let networkService = NetworkService.shared
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchDebounce()
        loadPopularMovies()
        
        coreDataManager.$favoritesChanged
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if searchText.isEmpty {
                    self?.isSearching = false
                    self?.searchResults = []
                } else {
                    self?.searchMovies(query: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadPopularMovies() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                print("Loading popular movies...")
                let moviePage = try await networkService.fetchPopularMovies()
                self.movies = moviePage.results ?? []
                print("Loaded \(self.movies.count) movies")
                
                // Fetch runtime for each movie
                for movie in self.movies {
                    if let movieId = movie.id {
                        await self.fetchMovieRuntime(movieId: movieId)
                    }
                }
            } catch {
                print("Error loading movies: \(error)")
                self.errorMessage = "Failed to load movies: \(error.localizedDescription)"
                self.showToastMessage("Network error: Unable to load movies")
            }
            self.isLoading = false
        }
    }
    
    private func searchMovies(query: String) {
        isSearching = true
        
        Task {
            do {
                print("Searching for: \(query)")
                let searchResults = try await networkService.searchMovies(query: query)
                self.searchResults = searchResults.results ?? []
                print("Found \(self.searchResults.count) search results")
            } catch {
                print("Search error: \(error)")
                self.errorMessage = "Search failed: \(error.localizedDescription)"
                self.showToastMessage("Search failed: Check your connection")
            }
            self.isSearching = false
        }
    }
    
    func toggleFavorite(movie: Result, runtime: Int? = nil) {
        guard let movieId = movie.id else { return }
        
        if coreDataManager.isFavorite(movieId: movieId) {
            coreDataManager.removeFromFavorites(movieId: movieId)
        } else {
            coreDataManager.addToFavorites(movie: movie, runtime: runtime)
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        coreDataManager.isFavorite(movieId: movieId)
    }
    
    func getImageURL(path: String?) -> String? {
        networkService.getImageURL(path: path)
    }
    
    private func fetchMovieRuntime(movieId: Int) async {
        do {
            let movieDetails = try await networkService.fetchMovieDetails(id: movieId)
            if let runtime = movieDetails.runtime {
                await MainActor.run {
                    self.movieRuntimes[movieId] = runtime
                }
            }
        } catch {
            print("Failed to fetch runtime for movie \(movieId): \(error)")
        }
    }
    
    func getRuntime(for movieId: Int) -> Int? {
        movieRuntimes[movieId]
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }
    }
}
