//
//  MovieDetailView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import SafariServices

struct MovieDetailView: View {
    let movie: Result
    @StateObject private var viewModel = MovieDetailViewModel()

    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16.adaptedHeight) {
                    // Header Image
                    AsyncImage(url: URL(string: viewModel.getImageURL(path: movie.backdropPath) ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 250.adaptedHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 12.adaptedWidth))
                    .overlay(
                        VStack {
                            Spacer()
                            if !viewModel.trailers.isEmpty {
                                Button(action: {
                                    if let trailer = viewModel.trailers.first,
                                       let key = trailer.key {
                                        openYouTubeApp(videoKey: key)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                        Text("Watch Trailer")
                                    }
                                    .padding(12.adaptedWidth)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                }
                                .padding(.bottom, 20.adaptedHeight)
                            }
                        }
                    )
                    
                    VStack(alignment: .leading, spacing: 12.adaptedHeight) {
                        // Title and Favorite
                        HStack {
                            Text(movie.title ?? "Unknown Title")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    viewModel.toggleFavorite(movie: movie)
                                }
                            }) {
                                Image(systemName: viewModel.isFavorite(movieId: movie.id ?? 0) ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isFavorite(movieId: movie.id ?? 0) ? .red : .gray)
                                    .font(.title)
                                    .scaleEffect(viewModel.isFavorite(movieId: movie.id ?? 0) ? 1.2 : 1.0)
                            }
                        }
                        
                        // Movie Info
                        HStack(spacing: 16.adaptedWidth) {
                            if let runtime = viewModel.movieDetails?.runtime {
                                Label(runtime.formatRuntime(), systemImage: "clock")
                            }
                            
                            Label((movie.voteAverage ?? 0.0).formatRating(), systemImage: "star.fill")
                                .foregroundColor(.yellow)
                            
                            if let releaseDate = movie.releaseDate {
                                Label(String(releaseDate.prefix(4)), systemImage: "calendar")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        // Genres
                        if let genres = viewModel.movieDetails?.genres, !genres.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(genres, id: \.id) { genre in
                                        Text(genre.name ?? "")
                                            .padding(.horizontal, 12.adaptedWidth)
                                            .padding(.vertical, 6.adaptedHeight)
                                            .background(Color.blue.opacity(0.2))
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.horizontal, 16.adaptedWidth)
                            }
                        }
                        
                        // Overview
                        if let overview = movie.overview, !overview.isEmpty {
                            Text("Overview")
                                .font(.headline)
                            
                            Text(overview)
                                .font(.body)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.horizontal, 16.adaptedWidth)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let movieId = movie.id {
                    viewModel.loadMovieDetails(id: movieId)
                }
            }
            
            ToastView(message: viewModel.toastMessage, isShowing: $viewModel.showToast)
        }
    }
    
    private func openYouTubeApp(videoKey: String) {
        let youtubeAppURL = URL(string: "youtube://watch?v=\(videoKey)")
        let youtubeWebURL = URL(string: "https://www.youtube.com/watch?v=\(videoKey)")
        
        if let appURL = youtubeAppURL, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = youtubeWebURL {
            UIApplication.shared.open(webURL)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    MovieDetailView(movie: Result(
        adult: false,
        backdropPath: nil,
        genreIDS: [],
        id: 1,
        originalLanguage: "en",
        originalTitle: "Test Movie",
        overview: "This is a test movie overview that should be long enough to show multiple lines of text.",
        popularity: 100.0,
        posterPath: nil,
        releaseDate: "2023-01-01",
        title: "Test Movie",
        video: false,
        voteAverage: 8.5,
        voteCount: 1000
    ))
}
