//
//  TimerView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPreset: TimerPreset? = nil
    @State private var showingCustomTimer = false
    @State private var showingTimerDetail = false
    @State private var searchText = ""
    @State private var selectedCategory: TimerPreset.TimerCategory? = nil
    
    var filteredPresets: [TimerPreset] {
        var presets = dataManager.timerPresets
        
        if !searchText.isEmpty {
            presets = presets.filter { preset in
                preset.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            presets = presets.filter { $0.category == category }
        }
        
        return presets
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Cooking Timers")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.tasteLogText)
                                
                                Text("Perfect timing for perfect cooking")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color.tasteLogText.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingCustomTimer = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color.tasteLogPrimary)
                            }
                        }
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.tasteLogText.opacity(0.6))
                            
                            TextField("Search timers...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(Color.tasteLogText)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.tasteLogCardBackground)
                        )
                        
                        // Category Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                CategoryFilterButton(
                                    title: "All",
                                    isSelected: selectedCategory == nil
                                ) {
                                    selectedCategory = nil
                                }
                                
                                ForEach(TimerPreset.TimerCategory.allCases, id: \.self) { category in
                                    CategoryFilterButton(
                                        title: category.rawValue,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Timer Presets Grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(filteredPresets) { preset in
                                TimerPresetCard(preset: preset) {
                                    selectedPreset = preset
                                    showingTimerDetail = true
                                    dataManager.incrementTimersUsed()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCustomTimer) {
            CustomTimerView()
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingTimerDetail) {
            if let preset = selectedPreset {
                TimerDetailView(duration: preset.duration, recipeName: preset.name)
                    .environmentObject(dataManager)
            }
        }
    }
}

struct TimerPresetCard: View {
    let preset: TimerPreset
    let action: () -> Void
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        } else if minutes > 0 {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        } else {
            return String(format: "0:%02d", remainingSeconds)
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icon and Category
                VStack(spacing: 8) {
                    Text(preset.icon)
                        .font(.system(size: 32))
                    
                    Text(preset.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.tasteLogAccent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.tasteLogAccent.opacity(0.2))
                        )
                }
                
                // Timer Name
                Text(preset.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.tasteLogText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Duration
                Text(formatDuration(preset.duration))
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.tasteLogPrimary)
                
                // Start Button
                Text("Start Timer")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.tasteLogBackground)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.tasteLogPrimary)
                    )
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
        }
        .buttonStyle(PlainButtonStyle())
        .tasteLogCard()
    }
}

#Preview {
    TimerView()
        .environmentObject(DataManager())
}
