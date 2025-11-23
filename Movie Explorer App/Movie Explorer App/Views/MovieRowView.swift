//
//  MovieRowView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import MarqueeText

struct MovieRowView: View {
    let movie: Result
    let runtime: Int?
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: NetworkService.shared.getImageURL(path: movie.posterPath) ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2/3, contentMode: .fill)
            }
            .clipped()
            
            VStack(alignment: .leading, spacing: 8.adaptedHeight) {
                HStack {
                         MarqueeText(
                            text: movie.title ?? "Unknown Title", font: UIFont.preferredFont(forTextStyle: .subheadline), leftFade: 16, rightFade: 16, startDelay: 3)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            onFavoriteToggle()
                        }
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .font(.title3)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                HStack(spacing: 16.adaptedWidth) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text((movie.voteAverage ?? 0.0).formatRating())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let runtime = runtime {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.secondary)
                                .font(.caption)
                            Text(runtime.formatRuntime())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(12.adaptedWidth)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12.adaptedWidth))
        .shadow(color: .black.opacity(0.1), radius: 4.adaptedWidth, x: 0, y: 2.adaptedHeight)
    }
}

#Preview {
    MovieRowView(
        movie: Result(
            adult: false,
            backdropPath: nil,
            genreIDS: [],
            id: 1,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            overview: "Test overview",
            popularity: 100.0,
            posterPath: nil,
            releaseDate: "2023-01-01",
            title: "Test Movie",
            video: false,
            voteAverage: 8.5,
            voteCount: 1000
        ),
        runtime: 120,
        isFavorite: false,
        onFavoriteToggle: {}
    )
    .padding()
}
