//
//  TabBarView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var moviesViewModel = MoviesViewModel()
    
    var body: some View {
        ZStack {
            TabView {
                MoviesListView()
                    .environmentObject(moviesViewModel)
                    .tabItem {
                        Image(systemName: "film")
                        Text("Movies")
                    }
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
            }
            .accentColor(.red)
            
            ToastView(message: moviesViewModel.toastMessage, isShowing: $moviesViewModel.showToast)
        }
    }
}

#Preview {
    TabBarView()
}
