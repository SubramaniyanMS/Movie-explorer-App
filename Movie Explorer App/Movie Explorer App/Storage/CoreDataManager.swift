//
//  CoreDataManager.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import Foundation
import CoreData
import UserNotifications
import Combine

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    @Published var favoritesChanged = false
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie_Explorer_App")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func addToFavorites(movie: Result, runtime: Int? = nil) {
        let favorite = FavoriteMovie(context: context)
        favorite.id = Int32(movie.id ?? 0)
        favorite.title = movie.title
        favorite.posterPath = movie.posterPath
        favorite.rating = movie.voteAverage ?? 0.0
        favorite.runtime = Int32(runtime ?? 0)
        favorite.isFavorite = true
        favorite.dateAdded = Date()
        
        save()
        favoritesChanged.toggle()
        sendFavoriteNotification(title: movie.title ?? "Movie")
    }
    
    func removeFromFavorites(movieId: Int) {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        
        if let favorite = try? context.fetch(request).first {
            context.delete(favorite)
            save()
            favoritesChanged.toggle()
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        return (try? context.fetch(request).first) != nil
    }
    
    func getFavorites() -> [FavoriteMovie] {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMovie.dateAdded, ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    private func sendFavoriteNotification(title: String) {
        let content = UNMutableNotificationContent()
        content.title = "Added to Favorites"
        content.body = "You added \(title) to Favorites!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
