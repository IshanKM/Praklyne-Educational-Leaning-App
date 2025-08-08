//
//  PraklyneApp.swift
//  Praklyne
//
//  Created by ISHAN-KM on 2025-08-07.
//

import SwiftUI

@main
struct PraklyneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
