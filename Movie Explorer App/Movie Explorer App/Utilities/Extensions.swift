//
//  Extensions.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI

extension View {
    func fadeInAnimation(delay: Double = 0) -> some View {
        self
            .opacity(1)
            .animation(.easeIn(duration: 0.5).delay(delay), value: UUID())
    }
    
    func scaleAnimation() -> some View {
        self
            .scaleEffect(0.8)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: true)
    }
}

extension FloatingPoint where Self: BinaryFloatingPoint {
    
    static var designWidth: Self {
        
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 412 : 800
    }
    
    static var designHeight: Self {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width ? 917 : 1280
    }
    
    var adaptedWidth: CGFloat {
        return (CGFloat(self) * (UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.width : UIScreen.main.bounds.height)) / CGFloat(Self.designWidth)
    }
    
    var adaptedHeight: CGFloat {
        return (CGFloat(self) * (UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.height : UIScreen.main.bounds.width)) / CGFloat(Self.designHeight)
    }
    
    var hasDecimalPart: Bool {
        return self.truncatingRemainder(dividingBy: 1) != 0
    }
    
}

extension Double {
    func formatRating() -> String {
        String(format: "%.1f", self)
    }
}

extension Int {
    func formatRuntime() -> String {
        let hours = self / 60
        let minutes = self % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
