//
//  HistoryView.swift
//  CaffeineTracker
//
//  Created by Josh Jung on 3/3/25.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var caffeineStore: CaffeineStore
    @State private var showingConfirmation = false
    
    var body: some View {
        List {
            ForEach(groupedByDay.keys.sorted(by: >), id: \.self) { day in
                Section(header: Text(formatDate(day))) {
                    let drinks = groupedByDay[day] ?? []
                    
                    ForEach(drinks) { drink in
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
                    
                    HStack {
                        Text("Total:")
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(totalForDay(day)) mg")
                            .fontWeight(.medium)
                    }
                }
            }
            
            if caffeineStore.drinks.isEmpty {
                Text("No history to display")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            }
        }
        .navigationTitle("History")
        .toolbar {
            if !caffeineStore.drinks.isEmpty {
                Button(action: {
                    showingConfirmation = true
                }) {
                    Label("Clear", systemImage: "trash")
                }
            }
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Clear History"),
                message: Text("Are you sure you want to clear all history?"),
                primaryButton: .destructive(Text("Clear")) {
                    caffeineStore.clearHistory()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var groupedByDay: [Date: [CaffeineDrink]] {
        let calendar = Calendar.current
        
        var grouped: [Date: [CaffeineDrink]] = [:]
        
        for drink in caffeineStore.drinks {
            let date = calendar.startOfDay(for: drink.timestamp)
            if grouped[date] == nil {
                grouped[date] = []
            }
            grouped[date]?.append(drink)
        }
        
        // Sort drinks by time within each day
        for (day, drinks) in grouped {
            grouped[day] = drinks.sorted { $0.timestamp > $1.timestamp }
        }
        
        return grouped
    }
    
    private func totalForDay(_ day: Date) -> Int {
        let drinks = groupedByDay[day] ?? []
        return drinks.reduce(0) { $0 + $1.caffeine }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }
}
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
                .environmentObject(CaffeineStore())
        }
        
    }
}
