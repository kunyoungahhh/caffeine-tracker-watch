//
//  ContentView.swift
//  CaffeineTracker Watch App
//
//  Created by Josh Jung on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var caffeineStore: CaffeineStore
    @State private var showingAddDrink = false
    
    var body: some View {
        List {
            CaffeineStatsView()
                .listRowBackground(Color.clear)
            
            Section(header: Text("Today's Drinks")) {
                if todaysDrinks.isEmpty {
                    Text("No drinks logged today")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 5)
                } else {
                    ForEach(todaysDrinks) { drink in
                        HStack {
                            Text(drink.name)
                            Spacer()
                            Text("\(drink.caffeine) mg")
                                .foregroundColor(.secondary)
                            Text(timeFormatter.string(from: drink.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeDrink)
                }
            }
            
            Section {
                Button(action: { showingAddDrink = true }) {
                    Label("Add Drink", systemImage: "plus.circle.fill")
                }
                
                NavigationLink(destination: HistoryView().environmentObject(caffeineStore)) {
                    Label("History", systemImage: "clock")
                }
            }
        }
        .navigationTitle("Caffeine")
        .sheet(isPresented: $showingAddDrink) {
            AddDrinkView()
                .environmentObject(caffeineStore)
        }
    }
    
    private var todaysDrinks: [CaffeineDrink] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return caffeineStore.drinks
            .filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }
    
    private func removeDrink(at offsets: IndexSet) {
        let drinkIndices = offsets.map { todaysDrinks[$0] }
        
        for drink in drinkIndices {
            if let index = caffeineStore.drinks.firstIndex(where: { $0.id == drink.id }) {
                caffeineStore.drinks.remove(at: index)
            }
        }
        
        caffeineStore.saveDrinks()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CaffeineStore())
    }
}
