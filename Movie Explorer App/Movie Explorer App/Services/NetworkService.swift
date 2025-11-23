//
//  NetworkService.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import Foundation
import Network
import Combine
import Alamofire

class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "e4a7b4a5adfd738ad66341ad5d772381"
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    @Published var isConnected = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        startNetworkMonitoring()
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    func fetchPopularMovies() async throws -> MovieListPage {
        let url = "\(baseURL)/movie/popular?api_key=\(apiKey)"
        return try await performRequest(url: url, type: MovieListPage.self)
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieListDetails {
        let url = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        return try await performRequest(url: url, type: MovieListDetails.self)
    }
    
    func fetchMovieTrailers(id: Int) async throws -> MovieTrailers {
        let url = "\(baseURL)/movie/\(id)/videos?api_key=\(apiKey)"
        return try await performRequest(url: url, type: MovieTrailers.self)
    }
    
    func searchMovies(query: String) async throws -> SearchList {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)"
        return try await performRequest(url: url, type: SearchList.self)
    }
    
    private func performRequest<T: Codable>(url: String, type: T.Type) async throws -> T {
        print("Making request to: \(url)")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: type) { response in
                    print("Response status: \(response.response?.statusCode ?? 0)")
                    
                    switch response.result {
                    case .success(let data):
                        print("Successfully decoded \(type)")
                        continuation.resume(returning: data)
                    case .failure(let error):
                        print("Network error: \(error)")
                        if let data = response.data {
                            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                        }
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func getImageURL(path: String?) -> String? {
        guard let path = path else { return nil }
        return "\(imageBaseURL)\(path)"
    }
}
