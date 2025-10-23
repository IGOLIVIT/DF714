//
//  RecipesView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedCategory: Recipe.RecipeCategory? = nil
    @State private var showingRecipeDetail = false
    @State private var selectedRecipe: Recipe? = nil
    
    var filteredRecipes: [Recipe] {
        var recipes = dataManager.recipes
        
        if !searchText.isEmpty {
            recipes = recipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.description.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined().localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            recipes = recipes.filter { $0.category == category }
        }
        
        return recipes
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
                                Text("Recipe Collection")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.tasteLogText)
                                
                                Text("Discover delicious recipes")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color.tasteLogText.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chef.hat")
                                .font(.system(size: 24))
                                .foregroundColor(Color.tasteLogPrimary)
                        }
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.tasteLogText.opacity(0.6))
                            
                            TextField("Search recipes...", text: $searchText)
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
                                
                                ForEach(Recipe.RecipeCategory.allCases, id: \.self) { category in
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
                    
                    // Recipes List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                                RecipeCard(recipe: recipe) {
                                    selectedRecipe = recipe
                                    showingRecipeDetail = true
                                    dataManager.incrementRecipesViewed()
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
        .sheet(isPresented: $showingRecipeDetail) {
            if let recipe = selectedRecipe {
                RecipeDetailView(recipe: recipe)
                    .environmentObject(dataManager)
            }
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color.tasteLogBackground : Color.tasteLogText.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.tasteLogPrimary : Color.tasteLogCardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.tasteLogText)
                            .multilineTextAlignment(.leading)
                        
                        Text(recipe.description)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color.tasteLogText.opacity(0.8))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 16))
                            .foregroundColor(Color.tasteLogPrimary)
                        
                        Text("\(recipe.prepTime) min")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.tasteLogText.opacity(0.7))
                    }
                }
                
                HStack {
                    // Category Badge
                    Text(recipe.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.tasteLogBackground)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.tasteLogAccent)
                        )
                    
                    // Difficulty Badge
                    Text(recipe.difficulty.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.tasteLogBackground)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(difficultyColor(recipe.difficulty))
                        )
                    
                    Spacer()
                    
                    Text("View Recipe")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.tasteLogPrimary)
                }
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
        .tasteLogCard()
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

#Preview {
    RecipesView()
        .environmentObject(DataManager())
}
