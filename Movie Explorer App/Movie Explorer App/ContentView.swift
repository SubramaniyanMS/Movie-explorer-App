//
//  ContentView.swift
//  Movie Explorer App
//
//  Created by Subramaniyan on 22/11/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabBarView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
