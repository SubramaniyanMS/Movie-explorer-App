//
//  MovieDetailViewModel.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetails: MovieListDetails?
    @Published var trailers: [TrailerResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showToast = false
    @Published var toastMessage = ""
    
    private let networkService = NetworkService.shared
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        coreDataManager.$favoritesChanged
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func loadMovieDetails(id: Int) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                async let details = networkService.fetchMovieDetails(id: id)
                async let trailerData = networkService.fetchMovieTrailers(id: id)
                
                self.movieDetails = try await details
                let trailerResults = try await trailerData
                self.trailers = trailerResults.results?.filter { $0.site == "YouTube" && $0.type == "Trailer" } ?? []
            } catch {
                self.errorMessage = error.localizedDescription
                self.showToastMessage("Failed to load movie details")
            }
            self.isLoading = false
        }
    }
    
    func toggleFavorite(movie: Result) {
        guard let movieId = movie.id else { return }
        
        if coreDataManager.isFavorite(movieId: movieId) {
            coreDataManager.removeFromFavorites(movieId: movieId)
        } else {
            coreDataManager.addToFavorites(movie: movie, runtime: movieDetails?.runtime)
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        coreDataManager.isFavorite(movieId: movieId)
    }
    
    func getImageURL(path: String?) -> String? {
        networkService.getImageURL(path: path)
    }
    
    func getYouTubeURL(key: String) -> String {
        "https://www.youtube.com/watch?v=\(key)"
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }
    }
}
