//
//  AchievementsView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFilter: AchievementFilter = .all
    
    enum AchievementFilter: String, CaseIterable {
        case all = "All"
        case unlocked = "Unlocked"
        case locked = "Locked"
    }
    
    var filteredAchievements: [Achievement] {
        switch selectedFilter {
        case .all:
            return dataManager.achievements
        case .unlocked:
            return dataManager.achievements.filter { $0.isUnlocked }
        case .locked:
            return dataManager.achievements.filter { !$0.isUnlocked }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Stats
                    VStack(spacing: 16) {
                        let unlockedCount = dataManager.achievements.filter { $0.isUnlocked }.count
                        let totalCount = dataManager.achievements.count
                        
                        VStack(spacing: 8) {
                            Text("\(unlockedCount)/\(totalCount)")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(Color.tasteLogPrimary)
                            
                            Text("Achievements Unlocked")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.tasteLogText.opacity(0.7))
                        }
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.tasteLogCardBackground)
                                    .frame(height: 12)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.tasteLogPrimary, Color.tasteLogAccent]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(
                                        width: geometry.size.width * (totalCount > 0 ? Double(unlockedCount) / Double(totalCount) : 0),
                                        height: 12
                                    )
                                    .animation(.easeInOut(duration: 0.5), value: unlockedCount)
                            }
                        }
                        .frame(height: 12)
                        
                        // Filter Buttons
                        HStack(spacing: 12) {
                            ForEach(AchievementFilter.allCases, id: \.self) { filter in
                                Button(filter.rawValue) {
                                    selectedFilter = filter
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedFilter == filter ? Color.tasteLogBackground : Color.tasteLogText.opacity(0.7))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedFilter == filter ? Color.tasteLogPrimary : Color.tasteLogCardBackground)
                                )
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Achievements List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredAchievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.tasteLogPrimary)
                }
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private func requirementText() -> String {
        switch achievement.requirement {
        case .recipesViewed(let count):
            return "View \(count) recipes"
        case .notesCreated(let count):
            return "Create \(count) notes"
        case .timersUsed(let count):
            return "Use timers \(count) times"
        case .daysActive(let count):
            return "Be active for \(count) days"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Achievement Icon
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient(
                            gradient: Gradient(colors: [Color.tasteLogPrimary, Color.tasteLogAccent]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color.tasteLogCardBackground, Color.tasteLogCardBackground]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text(achievement.icon)
                    .font(.system(size: 28))
                    .opacity(achievement.isUnlocked ? 1.0 : 0.5)
                
                if achievement.isUnlocked {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.tasteLogBackground)
                                .background(
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 20, height: 20)
                                )
                                .offset(x: 8, y: 8)
                        }
                    }
                    .frame(width: 60, height: 60)
                }
            }
            
            // Achievement Details
            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(achievement.isUnlocked ? Color.tasteLogText : Color.tasteLogText.opacity(0.6))
                
                Text(achievement.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(achievement.isUnlocked ? Color.tasteLogText.opacity(0.8) : Color.tasteLogText.opacity(0.5))
                    .lineLimit(2)
                
                Text(requirementText())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(achievement.isUnlocked ? Color.tasteLogPrimary : Color.tasteLogText.opacity(0.4))
                
                if let date = achievement.unlockedDate {
                    Text("Unlocked \(dateFormatter.string(from: date))")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.green)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.tasteLogCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            achievement.isUnlocked ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.tasteLogPrimary.opacity(0.5), Color.tasteLogAccent.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: achievement.isUnlocked ? Color.tasteLogPrimary.opacity(0.3) : Color.tasteLogShadow,
                    radius: achievement.isUnlocked ? 8 : 4,
                    x: 0,
                    y: achievement.isUnlocked ? 4 : 2
                )
        )
        .scaleEffect(achievement.isUnlocked ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: achievement.isUnlocked)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(DataManager())
}

