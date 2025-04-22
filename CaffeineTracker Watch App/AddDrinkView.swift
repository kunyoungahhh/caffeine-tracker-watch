//
//  AddDrinkView.swift
//  CaffeineTracker
//
//  Created by Josh Jung on 3/3/25.
//

import SwiftUI

struct AddDrinkView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var caffeineStore: CaffeineStore
    
    @State private var selectedDrink = "Coffee (8oz)"
    @State private var customDrinkName = ""
    @State private var caffeineAmount = 95
    @State private var isCustom = false
    
    let drinks = CaffeineDrink.commonDrinks
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select Drink")) {
                    Toggle("Custom Drink", isOn: $isCustom)
                    
                    if isCustom {
                        TextField("Drink Name", text: $customDrinkName)
                        
                        Stepper(value: $caffeineAmount, in: 1...500) {
                            HStack {
                                Text("Caffeine:")
                                Spacer()
                                Text("\(caffeineAmount) mg")
                            }
                        }
                    } else {
                        Picker("Drink Type", selection: $selectedDrink) {
                            ForEach(Array(drinks.keys.sorted()), id: \.self) { drink in
                                Text(drink).tag(drink)
                            }
                        }
                        .onChange(of: selectedDrink) { newValue in
                            if let caffeine = drinks[newValue] {
                                caffeineAmount = caffeine
                            }
                        }
                    }
                }
                
                Section {
                    Button("Add Drink") {
                        let drink = CaffeineDrink(
                            name: isCustom ? customDrinkName : selectedDrink,
                            caffeine: caffeineAmount,
                            timestamp: Date()
                        )
                        caffeineStore.addDrink(drink)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(isCustom && customDrinkName.isEmpty)
                }
            }
            .navigationTitle("Add Drink")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
struct AddDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        AddDrinkView()
            .environmentObject(CaffeineStore())
    }
}
