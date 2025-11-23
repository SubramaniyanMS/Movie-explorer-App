//
//  ExtensionTests.swift
//  Movie Explorer AppTests
//
//  Created by Subramaniyan on 22/11/25.
//

import XCTest
import SwiftUI
@testable import Movie_Explorer_App

final class ExtensionTests: XCTestCase {
    
    // MARK: - Adaptive Sizing Tests
    func testAdaptedWidth() throws {
        let originalWidth: CGFloat = 100
        let adaptedWidth = originalWidth.adaptedWidth
        
        XCTAssertGreaterThan(adaptedWidth, 0)
        XCTAssertNotEqual(adaptedWidth, originalWidth) // Should be scaled
    }
    
    func testAdaptedHeight() throws {
        let originalHeight: CGFloat = 100
        let adaptedHeight = originalHeight.adaptedHeight
        
        XCTAssertGreaterThan(adaptedHeight, 0)
        XCTAssertNotEqual(adaptedHeight, originalHeight) // Should be scaled
    }
    
    func testDesignWidthAndHeight() throws {
        let designWidth = CGFloat.designWidth
        let designHeight = CGFloat.designHeight
        
        XCTAssertGreaterThan(designWidth, 0)
        XCTAssertGreaterThan(designHeight, 0)
        XCTAssertTrue(designWidth == 412 || designWidth == 800)
        XCTAssertTrue(designHeight == 917 || designHeight == 1280)
    }
    
    // MARK: - Double Extension Tests
    func testRatingFormattingWithDecimals() throws {
        let rating1 = 8.567
        XCTAssertEqual(rating1.formatRating(), "8.6")
        
        let rating2 = 7.123
        XCTAssertEqual(rating2.formatRating(), "7.1")
        
        let rating3 = 9.0
        XCTAssertEqual(rating3.formatRating(), "9.0")
    }
    
    func testRatingFormattingEdgeCases() throws {
        let zeroRating = 0.0
        XCTAssertEqual(zeroRating.formatRating(), "0.0")
        
        let maxRating = 10.0
        XCTAssertEqual(maxRating.formatRating(), "10.0")
        
        let negativeRating = -1.5
        XCTAssertEqual(negativeRating.formatRating(), "-1.5")
    }
    
    // MARK: - Int Extension Tests
    func testRuntimeFormattingHoursAndMinutes() throws {
        let runtime120 = 120 // 2 hours
        XCTAssertEqual(runtime120.formatRuntime(), "2h 0m")
        
        let runtime95 = 95 // 1 hour 35 minutes
        XCTAssertEqual(runtime95.formatRuntime(), "1h 35m")
        
        let runtime150 = 150 // 2 hours 30 minutes
        XCTAssertEqual(runtime150.formatRuntime(), "2h 30m")
    }
    
    func testRuntimeFormattingMinutesOnly() throws {
        let runtime45 = 45
        XCTAssertEqual(runtime45.formatRuntime(), "45m")
        
        let runtime30 = 30
        XCTAssertEqual(runtime30.formatRuntime(), "30m")
        
        let runtime1 = 1
        XCTAssertEqual(runtime1.formatRuntime(), "1m")
    }
    
    func testRuntimeFormattingEdgeCases() throws {
        let zeroRuntime = 0
        XCTAssertEqual(zeroRuntime.formatRuntime(), "0m")
        
        let exactHour = 60
        XCTAssertEqual(exactHour.formatRuntime(), "1h 0m")
        
        let longMovie = 180 // 3 hours
        XCTAssertEqual(longMovie.formatRuntime(), "3h 0m")
    }
    
    // MARK: - FloatingPoint Extension Tests
    func testHasDecimalPart() throws {
        let wholeNumber = 5.0
        XCTAssertFalse(wholeNumber.hasDecimalPart)
        
        let decimalNumber = 5.5
        XCTAssertTrue(decimalNumber.hasDecimalPart)
        
        let smallDecimal = 0.1
        XCTAssertTrue(smallDecimal.hasDecimalPart)
    }
}
