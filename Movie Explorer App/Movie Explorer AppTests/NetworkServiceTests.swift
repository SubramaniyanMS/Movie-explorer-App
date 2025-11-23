//
//  NetworkServiceTests.swift
//  Movie Explorer AppTests
//
//  Created by Subramaniyan on 22/11/25.
//

import XCTest
@testable import Movie_Explorer_App

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    
    override func setUpWithError() throws {
        networkService = NetworkService.shared
    }
    
    override func tearDownWithError() throws {
        networkService = nil
    }
    
    func testImageURLGeneration() throws {
        let posterPath = "/test.jpg"
        let imageURL = networkService.getImageURL(path: posterPath)
        
        XCTAssertNotNil(imageURL)
        XCTAssertTrue(imageURL?.contains("image.tmdb.org") == true)
        XCTAssertTrue(imageURL?.contains(posterPath) == true)
    }
    
    func testImageURLWithNilPath() throws {
        let imageURL = networkService.getImageURL(path: nil)
        XCTAssertNil(imageURL)
    }
    
    func testImageURLWithEmptyPath() throws {
        let imageURL = networkService.getImageURL(path: "")
        XCTAssertNil(imageURL)
    }
    
    func testYouTubeURLGeneration() throws {
        let videoKey = "dQw4w9WgXcQ"
        let youtubeURL = networkService.getYouTubeURL(key: videoKey)
        
        XCTAssertEqual(youtubeURL, "https://www.youtube.com/watch?v=\(videoKey)")
    }
    
    func testNetworkConnectivityInitialState() throws {
        XCTAssertTrue(networkService.isConnected)
    }
}
