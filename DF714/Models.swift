//
//  Models.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import Foundation

// MARK: - Recipe Model
struct Recipe: Identifiable, Codable {
    let id = UUID()
    let title: String
    let prepTime: Int // in minutes
    let description: String
    let ingredients: [String]
    let steps: [String]
    let category: RecipeCategory
    let difficulty: Difficulty
    
    enum RecipeCategory: String, CaseIterable, Codable {
        case appetizer = "Appetizer"
        case mainCourse = "Main Course"
        case dessert = "Dessert"
        case beverage = "Beverage"
        case snack = "Snack"
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

// MARK: - Note Model
struct CulinaryNote: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    let dateCreated: Date
    var dateModified: Date
    var category: NoteCategory
    
    enum NoteCategory: String, CaseIterable, Codable {
        case experiment = "Experiment"
        case tip = "Cooking Tip"
        case review = "Recipe Review"
        case idea = "Recipe Idea"
        case technique = "Technique"
    }
}

// MARK: - Timer Preset Model
struct TimerPreset: Identifiable, Codable {
    let id = UUID()
    let name: String
    let duration: Int // in seconds
    let category: TimerCategory
    let icon: String
    
    enum TimerCategory: String, CaseIterable, Codable {
        case boiling = "Boiling"
        case baking = "Baking"
        case grilling = "Grilling"
        case steaming = "Steaming"
        case general = "General"
    }
}

// MARK: - Achievement Model
struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let unlockedDate: Date?
    let requirement: AchievementRequirement
    
    enum AchievementRequirement: Codable {
        case recipesViewed(Int)
        case notesCreated(Int)
        case timersUsed(Int)
        case daysActive(Int)
    }
}

// MARK: - User Stats Model
struct UserStats: Codable {
    var recipesViewed: Int = 0
    var notesCreated: Int = 0
    var timersUsed: Int = 0
    var daysActive: Set<String> = [] // Store dates as strings
    var achievements: [Achievement] = []
    
    mutating func incrementRecipesViewed() {
        recipesViewed += 1
        addTodayToActiveDays()
    }
    
    mutating func incrementNotesCreated() {
        notesCreated += 1
        addTodayToActiveDays()
    }
    
    mutating func incrementTimersUsed() {
        timersUsed += 1
        addTodayToActiveDays()
    }
    
    private mutating func addTodayToActiveDays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        daysActive.insert(today)
    }
}
