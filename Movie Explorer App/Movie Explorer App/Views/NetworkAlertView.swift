//
//  NetworkAlertView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI

struct NetworkAlertView: View {
    @ObservedObject var networkService = NetworkService.shared
    @State private var showAlert = false
    
    var body: some View {
        EmptyView()
            .onChange(of: networkService.isConnected) {
                if !networkService.isConnected {
                    showAlert = true
                }
            }
            .alert("No Internet Connection", isPresented: $showAlert) {
                Button("OK") { }
                Button("Retry") {
                    // Trigger a retry mechanism
                }
            } message: {
                Text("Please check your internet connection and try again.")
            }
    }
}
