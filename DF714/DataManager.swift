//
//  DataManager.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var notes: [CulinaryNote] = []
    @Published var timerPresets: [TimerPreset] = []
    @Published var userStats = UserStats()
    @Published var achievements: [Achievement] = []
    @Published var hasCompletedOnboarding = false
    
    init() {
        loadSampleData()
        loadUserData()
        setupAchievements()
    }
    
    // MARK: - Sample Data
    private func loadSampleData() {
        // Sample Recipes
        recipes = [
            Recipe(
                title: "Creamy Mushroom Pasta",
                prepTime: 25,
                description: "Rich and creamy pasta with sautéed mushrooms and herbs",
                ingredients: [
                    "400g pasta (penne or fettuccine)",
                    "300g mixed mushrooms, sliced",
                    "200ml heavy cream",
                    "3 cloves garlic, minced",
                    "1 onion, diced",
                    "50g parmesan cheese, grated",
                    "2 tbsp olive oil",
                    "Fresh thyme and parsley",
                    "Salt and pepper to taste"
                ],
                steps: [
                    "Cook pasta according to package instructions until al dente",
                    "Heat olive oil in a large pan over medium heat",
                    "Sauté onion and garlic until fragrant",
                    "Add mushrooms and cook until golden brown",
                    "Pour in cream and simmer for 3-4 minutes",
                    "Add cooked pasta and toss with sauce",
                    "Stir in parmesan cheese and fresh herbs",
                    "Season with salt and pepper, serve immediately"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Spicy Chicken Wings",
                prepTime: 45,
                description: "Crispy baked wings with a spicy buffalo sauce glaze",
                ingredients: [
                    "1kg chicken wings",
                    "3 tbsp hot sauce",
                    "2 tbsp butter",
                    "1 tbsp honey",
                    "1 tsp garlic powder",
                    "1 tsp paprika",
                    "1/2 tsp cayenne pepper",
                    "Salt and pepper"
                ],
                steps: [
                    "Preheat oven to 220°C",
                    "Pat wings dry and season with salt, pepper, and spices",
                    "Arrange on baking sheet lined with parchment",
                    "Bake for 25-30 minutes until crispy",
                    "Mix hot sauce, butter, and honey in a bowl",
                    "Toss cooked wings in sauce mixture",
                    "Return to oven for 5 more minutes",
                    "Serve hot with celery sticks"
                ],
                category: .appetizer,
                difficulty: .easy
            ),
            Recipe(
                title: "Chocolate Lava Cake",
                prepTime: 20,
                description: "Decadent individual chocolate cakes with molten centers",
                ingredients: [
                    "100g dark chocolate, chopped",
                    "100g butter",
                    "2 large eggs",
                    "2 egg yolks",
                    "60g caster sugar",
                    "2 tbsp plain flour",
                    "Butter for ramekins",
                    "Cocoa powder for dusting"
                ],
                steps: [
                    "Preheat oven to 200°C",
                    "Butter 4 ramekins and dust with cocoa powder",
                    "Melt chocolate and butter in double boiler",
                    "Whisk eggs, yolks, and sugar until thick",
                    "Fold in melted chocolate mixture",
                    "Sift in flour and fold gently",
                    "Divide between ramekins",
                    "Bake for 12-14 minutes until edges are firm",
                    "Let cool for 1 minute, then invert onto plates"
                ],
                category: .dessert,
                difficulty: .medium
            ),
            Recipe(
                title: "Fresh Garden Salad",
                prepTime: 15,
                description: "Crisp mixed greens with seasonal vegetables and vinaigrette",
                ingredients: [
                    "Mixed salad greens (200g)",
                    "1 cucumber, sliced",
                    "2 tomatoes, wedged",
                    "1 red onion, thinly sliced",
                    "1 bell pepper, strips",
                    "3 tbsp olive oil",
                    "1 tbsp balsamic vinegar",
                    "1 tsp Dijon mustard",
                    "Salt and pepper"
                ],
                steps: [
                    "Wash and dry all vegetables thoroughly",
                    "Tear lettuce into bite-sized pieces",
                    "Slice cucumber and tomatoes",
                    "Arrange vegetables in a large bowl",
                    "Whisk olive oil, vinegar, and mustard",
                    "Season dressing with salt and pepper",
                    "Drizzle dressing over salad just before serving",
                    "Toss gently and serve immediately"
                ],
                category: .appetizer,
                difficulty: .easy
            ),
            Recipe(
                title: "Beef Stir Fry",
                prepTime: 30,
                description: "Quick and flavorful beef with crisp vegetables in savory sauce",
                ingredients: [
                    "500g beef sirloin, sliced thin",
                    "2 bell peppers, strips",
                    "1 broccoli head, florets",
                    "2 carrots, julienned",
                    "3 tbsp soy sauce",
                    "2 tbsp oyster sauce",
                    "1 tbsp cornstarch",
                    "2 tbsp vegetable oil",
                    "2 cloves garlic, minced",
                    "1 inch ginger, grated"
                ],
                steps: [
                    "Marinate beef in soy sauce and cornstarch for 15 minutes",
                    "Heat oil in wok or large pan over high heat",
                    "Stir-fry beef until browned, remove and set aside",
                    "Add vegetables to pan, stir-fry for 3-4 minutes",
                    "Add garlic and ginger, cook for 30 seconds",
                    "Return beef to pan with oyster sauce",
                    "Toss everything together for 1-2 minutes",
                    "Serve immediately over steamed rice"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Classic Caesar Salad",
                prepTime: 20,
                description: "Crisp romaine lettuce with homemade Caesar dressing and croutons",
                ingredients: [
                    "2 heads romaine lettuce, chopped",
                    "100g parmesan cheese, grated",
                    "2 cups bread cubes",
                    "3 cloves garlic, minced",
                    "2 anchovy fillets",
                    "1 egg yolk",
                    "2 tbsp lemon juice",
                    "1 tsp Dijon mustard",
                    "1/3 cup olive oil",
                    "Salt and black pepper"
                ],
                steps: [
                    "Toast bread cubes with olive oil until golden",
                    "Mash anchovies and garlic into a paste",
                    "Whisk together egg yolk, lemon juice, and mustard",
                    "Slowly add olive oil while whisking",
                    "Mix in anchovy paste and season",
                    "Toss lettuce with dressing",
                    "Top with croutons and parmesan",
                    "Serve immediately"
                ],
                category: .appetizer,
                difficulty: .medium
            ),
            Recipe(
                title: "Margherita Pizza",
                prepTime: 90,
                description: "Classic Italian pizza with fresh mozzarella, basil, and tomato sauce",
                ingredients: [
                    "500g pizza dough",
                    "200ml tomato sauce",
                    "250g fresh mozzarella, sliced",
                    "Fresh basil leaves",
                    "2 tbsp olive oil",
                    "2 cloves garlic, minced",
                    "Salt and pepper",
                    "Flour for dusting"
                ],
                steps: [
                    "Preheat oven to 250°C with pizza stone",
                    "Roll out dough on floured surface",
                    "Mix tomato sauce with garlic and seasoning",
                    "Spread sauce evenly on dough",
                    "Add mozzarella slices",
                    "Drizzle with olive oil",
                    "Bake for 10-12 minutes until golden",
                    "Top with fresh basil before serving"
                ],
                category: .mainCourse,
                difficulty: .hard
            ),
            Recipe(
                title: "Chicken Tikka Masala",
                prepTime: 45,
                description: "Tender chicken in creamy spiced tomato sauce",
                ingredients: [
                    "600g chicken breast, cubed",
                    "200ml Greek yogurt",
                    "400ml coconut milk",
                    "400g canned tomatoes",
                    "1 onion, diced",
                    "3 cloves garlic, minced",
                    "1 inch ginger, grated",
                    "2 tsp garam masala",
                    "1 tsp turmeric",
                    "1 tsp paprika",
                    "2 tbsp vegetable oil"
                ],
                steps: [
                    "Marinate chicken in yogurt and spices for 30 minutes",
                    "Cook chicken in oil until browned, set aside",
                    "Sauté onion, garlic, and ginger until soft",
                    "Add spices and cook for 1 minute",
                    "Add tomatoes and simmer for 10 minutes",
                    "Stir in coconut milk and return chicken",
                    "Simmer for 15 minutes until thick",
                    "Serve with rice and naan bread"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Fish and Chips",
                prepTime: 40,
                description: "Crispy beer-battered fish with golden chips",
                ingredients: [
                    "4 white fish fillets",
                    "4 large potatoes, cut into chips",
                    "200g plain flour",
                    "250ml cold beer",
                    "1 tsp baking powder",
                    "Oil for deep frying",
                    "Salt and pepper",
                    "Malt vinegar",
                    "Mushy peas to serve"
                ],
                steps: [
                    "Heat oil to 180°C for frying",
                    "Cut potatoes and soak in cold water",
                    "Mix flour, beer, and baking powder for batter",
                    "Fry chips until golden, drain and season",
                    "Coat fish in flour, then batter",
                    "Fry fish for 4-5 minutes until golden",
                    "Drain on paper towels",
                    "Serve with chips, mushy peas, and vinegar"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Beef Tacos",
                prepTime: 25,
                description: "Seasoned ground beef in soft tortillas with fresh toppings",
                ingredients: [
                    "500g ground beef",
                    "8 soft tortillas",
                    "1 onion, diced",
                    "2 cloves garlic, minced",
                    "1 tbsp chili powder",
                    "1 tsp cumin",
                    "1 tsp paprika",
                    "Lettuce, shredded",
                    "Tomatoes, diced",
                    "Cheese, grated",
                    "Sour cream",
                    "Salsa"
                ],
                steps: [
                    "Cook onion and garlic until soft",
                    "Add ground beef and cook until browned",
                    "Season with spices and cook 2 minutes",
                    "Warm tortillas in dry pan",
                    "Fill tortillas with beef mixture",
                    "Top with lettuce, tomatoes, and cheese",
                    "Add sour cream and salsa",
                    "Serve immediately"
                ],
                category: .mainCourse,
                difficulty: .easy
            ),
            Recipe(
                title: "Chicken Parmesan",
                prepTime: 35,
                description: "Breaded chicken breast with marinara sauce and melted cheese",
                ingredients: [
                    "4 chicken breasts, pounded thin",
                    "2 cups breadcrumbs",
                    "100g parmesan cheese, grated",
                    "2 eggs, beaten",
                    "300ml marinara sauce",
                    "200g mozzarella cheese, sliced",
                    "1/2 cup flour",
                    "Olive oil for frying",
                    "Fresh basil",
                    "Salt and pepper"
                ],
                steps: [
                    "Preheat oven to 200°C",
                    "Mix breadcrumbs with parmesan",
                    "Dredge chicken in flour, egg, then breadcrumbs",
                    "Fry chicken until golden on both sides",
                    "Place in baking dish with marinara sauce",
                    "Top with mozzarella cheese",
                    "Bake for 15-20 minutes until cheese melts",
                    "Garnish with fresh basil"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Pad Thai",
                prepTime: 30,
                description: "Thai stir-fried rice noodles with shrimp and vegetables",
                ingredients: [
                    "200g rice noodles",
                    "300g shrimp, peeled",
                    "3 eggs, beaten",
                    "2 cups bean sprouts",
                    "3 green onions, chopped",
                    "3 tbsp fish sauce",
                    "2 tbsp tamarind paste",
                    "2 tbsp brown sugar",
                    "2 tbsp vegetable oil",
                    "Crushed peanuts",
                    "Lime wedges",
                    "Chili flakes"
                ],
                steps: [
                    "Soak rice noodles in warm water until soft",
                    "Mix fish sauce, tamarind, and sugar for sauce",
                    "Heat oil in wok over high heat",
                    "Cook shrimp until pink, remove",
                    "Scramble eggs in same pan",
                    "Add drained noodles and sauce",
                    "Toss with bean sprouts and green onions",
                    "Serve with peanuts, lime, and chili"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Lasagna Bolognese",
                prepTime: 120,
                description: "Layered pasta with rich meat sauce and creamy béchamel",
                ingredients: [
                    "12 lasagna sheets",
                    "500g ground beef",
                    "500g ground pork",
                    "800g canned tomatoes",
                    "1 onion, diced",
                    "2 carrots, diced",
                    "2 celery stalks, diced",
                    "500ml milk",
                    "50g butter",
                    "50g flour",
                    "200g parmesan cheese",
                    "Red wine",
                    "Herbs and spices"
                ],
                steps: [
                    "Make bolognese sauce with meat and vegetables",
                    "Simmer with tomatoes and wine for 1 hour",
                    "Make béchamel sauce with butter, flour, and milk",
                    "Cook lasagna sheets until al dente",
                    "Layer sauce, pasta, and béchamel in dish",
                    "Repeat layers, top with parmesan",
                    "Bake at 180°C for 45 minutes",
                    "Rest for 10 minutes before serving"
                ],
                category: .mainCourse,
                difficulty: .hard
            ),
            Recipe(
                title: "Chicken Curry",
                prepTime: 40,
                description: "Aromatic Indian-style chicken curry with coconut milk",
                ingredients: [
                    "800g chicken thighs, cubed",
                    "400ml coconut milk",
                    "2 onions, sliced",
                    "4 cloves garlic, minced",
                    "2 inch ginger, grated",
                    "2 tbsp curry powder",
                    "1 tsp turmeric",
                    "1 tsp cumin",
                    "2 tbsp tomato paste",
                    "2 tbsp vegetable oil",
                    "Fresh cilantro",
                    "Basmati rice"
                ],
                steps: [
                    "Heat oil and cook onions until golden",
                    "Add garlic, ginger, and spices",
                    "Cook for 1 minute until fragrant",
                    "Add chicken and brown on all sides",
                    "Stir in tomato paste and coconut milk",
                    "Simmer for 25 minutes until tender",
                    "Season with salt and pepper",
                    "Serve with rice and cilantro"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Greek Moussaka",
                prepTime: 90,
                description: "Layered eggplant casserole with meat sauce and béchamel",
                ingredients: [
                    "3 large eggplants, sliced",
                    "500g ground lamb",
                    "2 onions, diced",
                    "400g canned tomatoes",
                    "500ml milk",
                    "50g butter",
                    "50g flour",
                    "100g kefalotiri cheese",
                    "2 eggs",
                    "Olive oil",
                    "Cinnamon",
                    "Oregano"
                ],
                steps: [
                    "Salt eggplant slices and let drain",
                    "Fry eggplant until golden, set aside",
                    "Cook lamb with onions and tomatoes",
                    "Season with cinnamon and oregano",
                    "Make béchamel sauce with butter, flour, milk",
                    "Layer eggplant and meat in baking dish",
                    "Top with béchamel and cheese",
                    "Bake at 180°C for 45 minutes"
                ],
                category: .mainCourse,
                difficulty: .hard
            ),
            Recipe(
                title: "Sushi Rolls",
                prepTime: 60,
                description: "Fresh salmon and avocado sushi rolls with sushi rice",
                ingredients: [
                    "2 cups sushi rice",
                    "4 nori sheets",
                    "200g fresh salmon, sliced",
                    "1 avocado, sliced",
                    "1 cucumber, julienned",
                    "3 tbsp rice vinegar",
                    "1 tbsp sugar",
                    "1 tsp salt",
                    "Wasabi",
                    "Soy sauce",
                    "Pickled ginger",
                    "Sesame seeds"
                ],
                steps: [
                    "Cook sushi rice according to package",
                    "Season rice with vinegar, sugar, and salt",
                    "Let rice cool to room temperature",
                    "Place nori on bamboo mat",
                    "Spread rice evenly on nori",
                    "Add salmon, avocado, and cucumber",
                    "Roll tightly using bamboo mat",
                    "Slice with sharp knife and serve"
                ],
                category: .mainCourse,
                difficulty: .hard
            ),
            Recipe(
                title: "BBQ Ribs",
                prepTime: 180,
                description: "Slow-cooked pork ribs with smoky barbecue sauce",
                ingredients: [
                    "2kg pork ribs",
                    "2 tbsp brown sugar",
                    "2 tbsp paprika",
                    "1 tbsp garlic powder",
                    "1 tbsp onion powder",
                    "1 tsp cayenne pepper",
                    "200ml BBQ sauce",
                    "2 tbsp apple cider vinegar",
                    "1 tbsp Worcestershire sauce",
                    "Salt and black pepper"
                ],
                steps: [
                    "Mix all dry spices for rub",
                    "Coat ribs with spice rub",
                    "Let marinate for 2 hours",
                    "Preheat oven to 150°C",
                    "Wrap ribs in foil and bake 2.5 hours",
                    "Mix BBQ sauce with vinegar",
                    "Brush ribs with sauce",
                    "Grill for 10 minutes to caramelize"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Ramen Bowl",
                prepTime: 45,
                description: "Rich tonkotsu-style ramen with pork belly and soft-boiled egg",
                ingredients: [
                    "4 portions fresh ramen noodles",
                    "1L chicken stock",
                    "200ml miso paste",
                    "300g pork belly, sliced",
                    "4 soft-boiled eggs",
                    "2 green onions, chopped",
                    "1 sheet nori, cut",
                    "100g bamboo shoots",
                    "2 cloves garlic, minced",
                    "1 tbsp sesame oil",
                    "Corn kernels"
                ],
                steps: [
                    "Prepare soft-boiled eggs, peel and halve",
                    "Cook pork belly until crispy",
                    "Heat chicken stock with miso paste",
                    "Cook ramen noodles according to package",
                    "Divide noodles between bowls",
                    "Pour hot broth over noodles",
                    "Top with pork, egg, and vegetables",
                    "Garnish with nori and green onions"
                ],
                category: .mainCourse,
                difficulty: .medium
            ),
            Recipe(
                title: "Tiramisu",
                prepTime: 30,
                description: "Classic Italian dessert with coffee-soaked ladyfingers and mascarpone",
                ingredients: [
                    "6 egg yolks",
                    "150g sugar",
                    "500g mascarpone cheese",
                    "400ml strong coffee, cooled",
                    "3 tbsp coffee liqueur",
                    "2 packages ladyfinger cookies",
                    "Cocoa powder for dusting",
                    "Dark chocolate, grated"
                ],
                steps: [
                    "Whisk egg yolks and sugar until thick",
                    "Fold in mascarpone until smooth",
                    "Mix coffee with liqueur in shallow dish",
                    "Quickly dip ladyfingers in coffee mixture",
                    "Layer dipped cookies in serving dish",
                    "Spread half the mascarpone mixture",
                    "Repeat layers, ending with mascarpone",
                    "Chill 4 hours, dust with cocoa before serving"
                ],
                category: .dessert,
                difficulty: .medium
            ),
            Recipe(
                title: "Smoothie Bowl",
                prepTime: 10,
                description: "Healthy acai smoothie bowl with fresh fruits and granola",
                ingredients: [
                    "1 frozen acai packet",
                    "1 frozen banana",
                    "1/2 cup frozen berries",
                    "1/4 cup almond milk",
                    "1 tbsp honey",
                    "Fresh strawberries, sliced",
                    "Fresh blueberries",
                    "Granola",
                    "Coconut flakes",
                    "Chia seeds",
                    "Mint leaves"
                ],
                steps: [
                    "Blend acai, banana, berries with almond milk",
                    "Add honey and blend until thick",
                    "Pour into serving bowl",
                    "Arrange fresh fruits on top",
                    "Sprinkle with granola and coconut",
                    "Add chia seeds for extra nutrition",
                    "Garnish with fresh mint",
                    "Serve immediately"
                ],
                category: .snack,
                difficulty: .easy
            )
        ]
        
        // Sample Notes
        notes = [
            CulinaryNote(
                title: "Perfect Pasta Water",
                content: "Always salt your pasta water generously - it should taste like seawater. This is your only chance to season the pasta itself. Save some pasta water before draining; the starchy water helps bind sauces beautifully.",
                dateCreated: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                dateModified: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                category: .tip
            ),
            CulinaryNote(
                title: "Mushroom Experiment",
                content: "Tried adding shiitake mushrooms to the creamy pasta recipe today. The earthy flavor was incredible! Next time I'll use a mix of shiitake and oyster mushrooms for even more depth. Also discovered that letting mushrooms cook undisturbed for the first 3-4 minutes creates better browning.",
                dateCreated: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                dateModified: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                category: .experiment
            ),
            CulinaryNote(
                title: "Spice Blend Discovery",
                content: "Created an amazing spice blend for chicken: 2 parts paprika, 1 part garlic powder, 1 part onion powder, 1/2 part cayenne, 1/4 part cinnamon. The cinnamon adds unexpected warmth without being sweet. Perfect for wings and grilled chicken.",
                dateCreated: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                dateModified: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                category: .technique
            ),
            CulinaryNote(
                title: "Chocolate Cake Success",
                content: "Finally mastered the lava cake! The secret is slightly underbaking - 12 minutes at 200°C is perfect. The centers should still jiggle slightly when you shake the ramekin. Serving immediately is crucial; they firm up quickly as they cool.",
                dateCreated: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                dateModified: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                category: .review
            )
        ]
        
        // Timer Presets
        timerPresets = [
            TimerPreset(name: "Soft Boiled Eggs", duration: 420, category: .boiling, icon: "🥚"),
            TimerPreset(name: "Hard Boiled Eggs", duration: 600, category: .boiling, icon: "🥚"),
            TimerPreset(name: "Perfect Pasta", duration: 480, category: .boiling, icon: "🍝"),
            TimerPreset(name: "Steamed Vegetables", duration: 300, category: .steaming, icon: "🥦"),
            TimerPreset(name: "Chocolate Chip Cookies", duration: 720, category: .baking, icon: "🍪"),
            TimerPreset(name: "Pizza Dough Rise", duration: 3600, category: .general, icon: "🍕"),
            TimerPreset(name: "Grilled Chicken Breast", duration: 900, category: .grilling, icon: "🍗"),
            TimerPreset(name: "Rice Cooking", duration: 1080, category: .general, icon: "🍚"),
            TimerPreset(name: "Bread Baking", duration: 1800, category: .baking, icon: "🍞"),
            TimerPreset(name: "Tea Steeping", duration: 180, category: .general, icon: "🍵")
        ]
    }
    
    private func setupAchievements() {
        achievements = [
            Achievement(
                title: "Recipe Explorer",
                description: "View your first 5 recipes",
                icon: "🔍",
                isUnlocked: false,
                unlockedDate: nil,
                requirement: .recipesViewed(5)
            ),
            Achievement(
                title: "Master of Flavor",
                description: "Create 10 cooking notes",
                icon: "👨‍🍳",
                isUnlocked: false,
                unlockedDate: nil,
                requirement: .notesCreated(10)
            ),
            Achievement(
                title: "Timekeeper Chef",
                description: "Use timers 15 times",
                icon: "⏰",
                isUnlocked: false,
                unlockedDate: nil,
                requirement: .timersUsed(15)
            ),
            Achievement(
                title: "Dedicated Cook",
                description: "Cook for 7 different days",
                icon: "🏆",
                isUnlocked: false,
                unlockedDate: nil,
                requirement: .daysActive(7)
            )
        ]
    }
    
    // MARK: - Data Persistence
    private func loadUserData() {
        if let data = UserDefaults.standard.data(forKey: "userStats"),
           let stats = try? JSONDecoder().decode(UserStats.self, from: data) {
            userStats = stats
        }
        
        if let data = UserDefaults.standard.data(forKey: "culinaryNotes"),
           let savedNotes = try? JSONDecoder().decode([CulinaryNote].self, from: data) {
            // Merge saved notes with sample notes, avoiding duplicates
            let savedNotesSet = Set(savedNotes.map { $0.id })
            let filteredSampleNotes = notes.filter { !savedNotesSet.contains($0.id) }
            notes = savedNotes + filteredSampleNotes
        }
        
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func saveUserData() {
        if let data = try? JSONEncoder().encode(userStats) {
            UserDefaults.standard.set(data, forKey: "userStats")
        }
        
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "culinaryNotes")
        }
        
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
    
    // MARK: - Notes Management
    func addNote(_ note: CulinaryNote) {
        notes.insert(note, at: 0)
        userStats.incrementNotesCreated()
        checkAchievements()
        saveUserData()
    }
    
    func updateNote(_ note: CulinaryNote) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveUserData()
        }
    }
    
    func deleteNote(_ note: CulinaryNote) {
        notes.removeAll { $0.id == note.id }
        saveUserData()
    }
    
    // MARK: - Stats Management
    func incrementRecipesViewed() {
        userStats.incrementRecipesViewed()
        checkAchievements()
        saveUserData()
    }
    
    func incrementTimersUsed() {
        userStats.incrementTimersUsed()
        checkAchievements()
        saveUserData()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveUserData()
    }
    
    func resetProgress() {
        userStats = UserStats()
        hasCompletedOnboarding = false
        setupAchievements()
        saveUserData()
    }
    
    // MARK: - Achievements
    private func checkAchievements() {
        for i in 0..<achievements.count {
            if !achievements[i].isUnlocked {
                let shouldUnlock: Bool
                switch achievements[i].requirement {
                case .recipesViewed(let count):
                    shouldUnlock = userStats.recipesViewed >= count
                case .notesCreated(let count):
                    shouldUnlock = userStats.notesCreated >= count
                case .timersUsed(let count):
                    shouldUnlock = userStats.timersUsed >= count
                case .daysActive(let count):
                    shouldUnlock = userStats.daysActive.count >= count
                }
                
                if shouldUnlock {
                    achievements[i] = Achievement(
                        title: achievements[i].title,
                        description: achievements[i].description,
                        icon: achievements[i].icon,
                        isUnlocked: true,
                        unlockedDate: Date(),
                        requirement: achievements[i].requirement
                    )
                }
            }
        }
    }
}
