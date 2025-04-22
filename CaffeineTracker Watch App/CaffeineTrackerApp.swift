//
//  CaffeineTrackerApp.swift
//  CaffeineTracker Watch App
//
//  Created by Josh Jung on 3/3/25.
//

import SwiftUI

@main
struct CaffeineTracker_Watch_AppApp: App {
    @StateObject private var caffeineStore = CaffeineStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(caffeineStore)
            }.environmentObject(caffeineStore)
        }
    }
}
