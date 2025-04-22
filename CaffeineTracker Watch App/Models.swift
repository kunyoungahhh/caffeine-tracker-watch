//
//  Models.swift
//  CaffeineTracker
//
//  Created by Josh Jung on 3/3/25.
//

import Foundation
import SwiftUI

struct CaffeineDrink: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var caffeine: Int // in mg
    var timestamp: Date
    
    static let commonDrinks: [String: Int] = [
        "Espresso": 63,
        "Coffee (8oz)": 95,
        "Latte": 75,
        "Black Tea": 47,
        "Green Tea": 28,
        "Energy Drink": 80,
        "Cola": 40
    ]
}

class CaffeineStore: ObservableObject {
    @Published var drinks: [CaffeineDrink] = []
    
    private let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SavedDrinks")
    
    init() {
        loadDrinks()
    }
    
    func addDrink(_ drink: CaffeineDrink) {
        drinks.append(drink)
        saveDrinks()
    }
    
    func removeDrink(at offsets: IndexSet) {
        drinks.remove(atOffsets: offsets)
        saveDrinks()
    }
    
    func saveDrinks() {
        do {
            let data = try JSONEncoder().encode(drinks)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data: \(error.localizedDescription)")
        }
    }
    
    func loadDrinks() {
        do {
            let data = try Data(contentsOf: savePath)
            drinks = try JSONDecoder().decode([CaffeineDrink].self, from: data)
        } catch {
            drinks = []
        }
    }
    
    func totalCaffeineToday() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return drinks
            .filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
            .reduce(0) { $0 + $1.caffeine }
    }
    
    func clearHistory() {
        drinks.removeAll()
        saveDrinks()
    }
}
