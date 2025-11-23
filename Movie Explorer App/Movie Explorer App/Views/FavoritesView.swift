//
//  FavoritesView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import MarqueeText

struct FavoritesView: View {
    @ObservedObject private var coreDataManager = CoreDataManager.shared
    @State private var favorites: [FavoriteMovie] = []
    
    var body: some View {
        NavigationView {
            if favorites.isEmpty {
                VStack(spacing: 20.adaptedHeight) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60.adaptedWidth))
                        .foregroundColor(.gray)
                    Text("No Favorites Yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Add movies to your favorites to see them here")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160.adaptedWidth), spacing: 16.adaptedWidth)], spacing: 16.adaptedHeight) {
                        ForEach(favorites, id: \.id) { favorite in
                            FavoriteMovieCard(favorite: favorite) {
                                removeFavorite(favorite)
                            }
                        }
                    }
                    .padding(.horizontal, 16.adaptedWidth)
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            loadFavorites()
        }
    }
    
    private func loadFavorites() {
        favorites = coreDataManager.getFavorites()
    }
    
    private func removeFavorite(_ favorite: FavoriteMovie) {
        coreDataManager.removeFromFavorites(movieId: Int(favorite.id))
        loadFavorites()
    }
}

struct FavoriteMovieCard: View {
    let favorite: FavoriteMovie
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: NetworkService.shared.getImageURL(path: favorite.posterPath) ?? "")) { image in
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
                       text: favorite.title ?? "Unknown Title", font: UIFont.preferredFont(forTextStyle: .subheadline), leftFade: 16, rightFade: 16, startDelay: 3)
                    
                    Spacer()
                    
                    Button(action: onRemove) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
                
                HStack(spacing: 16.adaptedWidth) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(favorite.rating.formatRating())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if favorite.runtime > 0 {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.secondary)
                                .font(.caption)
                            Text(Int(favorite.runtime).formatRuntime())
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
    FavoritesView()
}
