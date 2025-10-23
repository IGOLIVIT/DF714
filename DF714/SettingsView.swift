//
//  SettingsView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingResetAlert = false
    @State private var showingAchievements = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Settings")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(Color.tasteLogText)
                                    
                                    Text("Your culinary journey stats")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.tasteLogText.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.tasteLogPrimary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Cooking Stats Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Cooking Stats", icon: "chart.bar.fill")
                            
                            VStack(spacing: 16) {
                                StatCard(
                                    icon: "book.fill",
                                    title: "Recipes Viewed",
                                    value: "\(dataManager.userStats.recipesViewed)",
                                    color: Color.tasteLogPrimary
                                )
                                
                                StatCard(
                                    icon: "note.text",
                                    title: "Notes Created",
                                    value: "\(dataManager.userStats.notesCreated)",
                                    color: Color.tasteLogAccent
                                )
                                
                                StatCard(
                                    icon: "timer",
                                    title: "Timers Used",
                                    value: "\(dataManager.userStats.timersUsed)",
                                    color: Color.green
                                )
                                
                                StatCard(
                                    icon: "calendar",
                                    title: "Active Days",
                                    value: "\(dataManager.userStats.daysActive.count)",
                                    color: Color.blue
                                )
                            }
                            .padding(16)
                            .tasteLogCard()
                        }
                        .padding(.horizontal, 20)
                        
                        // Achievements Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Achievements", icon: "trophy.fill")
                            
                            VStack(spacing: 12) {
                                let unlockedCount = dataManager.achievements.filter { $0.isUnlocked }.count
                                let totalCount = dataManager.achievements.count
                                
                                HStack {
                                    Text("Progress")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color.tasteLogText)
                                    
                                    Spacer()
                                    
                                    Text("\(unlockedCount)/\(totalCount)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color.tasteLogPrimary)
                                }
                                
                                // Progress Bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.tasteLogCardBackground)
                                            .frame(height: 8)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.tasteLogPrimary)
                                            .frame(
                                                width: geometry.size.width * (totalCount > 0 ? Double(unlockedCount) / Double(totalCount) : 0),
                                                height: 8
                                            )
                                    }
                                }
                                .frame(height: 8)
                                
                                Button("View All Achievements") {
                                    showingAchievements = true
                                }
                                .buttonStyle(TasteLogButtonStyle(isPrimary: false))
                            }
                            .padding(16)
                            .tasteLogCard()
                        }
                        .padding(.horizontal, 20)
                        
                        // Recent Achievements
                        if !dataManager.achievements.filter({ $0.isUnlocked }).isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeader(title: "Recent Achievements", icon: "star.fill")
                                
                                VStack(spacing: 12) {
                                    ForEach(dataManager.achievements.filter { $0.isUnlocked }.prefix(3)) { achievement in
                                        AchievementRowView(achievement: achievement)
                                    }
                                }
                                .padding(16)
                                .tasteLogCard()
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Actions Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Actions", icon: "slider.horizontal.3")
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    showingResetAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color.red)
                                        
                                        Text("Reset Progress")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color.red)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.tasteLogText.opacity(0.5))
                                    }
                                    .padding(.vertical, 12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(16)
                            .tasteLogCard()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAchievements) {
            AchievementsView()
                .environmentObject(dataManager)
        }
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                dataManager.resetProgress()
            }
        } message: {
            Text("Are you sure you want to reset all your progress? This will clear all stats and achievements. This action cannot be undone.")
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.tasteLogText.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color.tasteLogText)
            }
            
            Spacer()
        }
    }
}

struct AchievementRowView: View {
    let achievement: Achievement
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(achievement.icon)
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.tasteLogPrimary.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.tasteLogText)
                
                Text(achievement.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.tasteLogText.opacity(0.7))
                    .lineLimit(2)
                
                if let date = achievement.unlockedDate {
                    Text("Unlocked \(dateFormatter.string(from: date))")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.tasteLogPrimary)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(DataManager())
}
