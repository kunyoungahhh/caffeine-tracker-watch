//
//  CaffeineStatsView.swift
//  CaffeineTracker
//
//  Created by Josh Jung on 3/3/25.
//

import SwiftUI

struct CaffeineStatsView: View {
    @EnvironmentObject var caffeineStore: CaffeineStore
    
    private let safeLimit = 400 // 400mg is often cited as safe for most adults
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(caffeineStore.totalCaffeineToday())")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                + Text(" mg")
                .font(.title)
            
            Text("TODAY")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProgressView(value: Double(caffeineStore.totalCaffeineToday()), total: Double(safeLimit))
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
            
            HStack {
                Text("0 mg")
                    .font(.caption2)
                Spacer()
                Text("\(safeLimit) mg")
                    .font(.caption2)
            }
            .foregroundColor(.secondary)
            .padding(.top, -5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
        )
    }
    
    private var progressColor: Color {
        let percentage = Double(caffeineStore.totalCaffeineToday()) / Double(safeLimit)
        
        if percentage < 0.5 {
            return .green
        } else if percentage < 0.8 {
            return .yellow
        } else {
            return .red
        }
    }
}
