//
//  RecipeDetailView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    let recipe: Recipe
    @State private var showingTimer = false
    @State private var selectedTimerDuration = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.title)
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(Color.tasteLogText)
                                    
                                    Text(recipe.description)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.tasteLogText.opacity(0.8))
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 16) {
                                InfoBadge(icon: "clock", text: "\(recipe.prepTime) min", color: Color.tasteLogPrimary)
                                InfoBadge(icon: "person.2", text: recipe.difficulty.rawValue, color: difficultyColor(recipe.difficulty))
                                InfoBadge(icon: "tag", text: recipe.category.rawValue, color: Color.tasteLogAccent)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Ingredients Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Ingredients", icon: "list.bullet")
                            
                            VStack(spacing: 12) {
                                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color.tasteLogPrimary)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.tasteLogPrimary.opacity(0.2))
                                            )
                                        
                                        Text(ingredient)
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color.tasteLogText)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(16)
                            .tasteLogCard()
                        }
                        .padding(.horizontal, 20)
                        
                        // Instructions Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Instructions", icon: "list.number")
                            
                            VStack(spacing: 16) {
                                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color.tasteLogBackground)
                                            .frame(width: 32, height: 32)
                                            .background(
                                                Circle()
                                                    .fill(Color.tasteLogPrimary)
                                            )
                                        
                                        Text(step)
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color.tasteLogText)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(16)
                            .tasteLogCard()
                        }
                        .padding(.horizontal, 20)
                        
                        // Timer Section
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Cooking Timer", icon: "timer")
                            
                            VStack(spacing: 16) {
                                Text("Set a timer to help you cook this recipe perfectly")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color.tasteLogText.opacity(0.7))
                                    .multilineTextAlignment(.leading)
                                
                                HStack(spacing: 12) {
                                    Button("15 min") {
                                        selectedTimerDuration = 900
                                        showingTimer = true
                                    }
                                    .buttonStyle(TasteLogButtonStyle(isPrimary: false))
                                    
                                    Button("30 min") {
                                        selectedTimerDuration = 1800
                                        showingTimer = true
                                    }
                                    .buttonStyle(TasteLogButtonStyle(isPrimary: false))
                                    
                                    Button("Custom") {
                                        selectedTimerDuration = recipe.prepTime * 60
                                        showingTimer = true
                                    }
                                    .buttonStyle(TasteLogButtonStyle(isPrimary: true))
                                }
                            }
                            .padding(16)
                            .tasteLogCard()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
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
        .sheet(isPresented: $showingTimer) {
            TimerDetailView(duration: selectedTimerDuration, recipeName: recipe.title)
                .environmentObject(dataManager)
        }
    }
    
    private func difficultyColor(_ difficulty: Recipe.Difficulty) -> Color {
        switch difficulty {
        case .easy:
            return Color.green
        case .medium:
            return Color.orange
        case .hard:
            return Color.red
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.tasteLogText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.2))
        )
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.tasteLogPrimary)
            
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(Color.tasteLogText)
            
            Spacer()
        }
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe(
        title: "Sample Recipe",
        prepTime: 30,
        description: "A delicious sample recipe",
        ingredients: ["Ingredient 1", "Ingredient 2"],
        steps: ["Step 1", "Step 2"],
        category: .mainCourse,
        difficulty: .medium
    ))
    .environmentObject(DataManager())
}
