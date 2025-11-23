//
//  ToastView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            if isShowing {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                    Text(message)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                }
                .padding(16.adaptedWidth)
                .background(Color.red)
                .cornerRadius(8.adaptedWidth)
                .padding(.horizontal, 16.adaptedWidth)
                .padding(.bottom, 100.adaptedHeight)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            isShowing = false
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}