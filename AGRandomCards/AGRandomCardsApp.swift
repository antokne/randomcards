//
//  AGRandomCardsApp.swift
//  AGRandomCards
//
//  Created by Ant Gardiner on 8/11/23.
//

import SwiftUI
import RandomCardsModel

@main
struct AGRandomCardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
