//
//  MoviesListView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI

struct MoviesListView: View {
    @EnvironmentObject var viewModel: MoviesViewModel

    
    var body: some View {
        NavigationView {
            VStack(spacing: 16.adaptedHeight) {
                
                NetworkAlertView()
                
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 16.adaptedWidth)
                
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Error: \(errorMessage)")
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            viewModel.loadPopularMovies()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160.adaptedWidth), spacing: 16.adaptedWidth)], spacing: 16.adaptedHeight) {
                            let movies = viewModel.isSearching || !viewModel.searchText.isEmpty ? viewModel.searchResults : viewModel.movies
                            
                            ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieRowView(
                                        movie: movie,
                                        runtime: viewModel.getRuntime(for: movie.id ?? 0),
                                        isFavorite: viewModel.isFavorite(movieId: movie.id ?? 0),
                                        onFavoriteToggle: {
                                            viewModel.toggleFavorite(movie: movie)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .fadeInAnimation(delay: Double(index) * 0.1)
                            }
                        }
                        .padding(.horizontal, 16.adaptedWidth)
                    }
                    .refreshable {
                        viewModel.loadPopularMovies()
                    }
                }
            }
            .navigationTitle("Popular Movies")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search movies...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    MoviesListView()
        .environmentObject(MoviesViewModel())
}
