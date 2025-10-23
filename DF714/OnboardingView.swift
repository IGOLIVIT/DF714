//
//  OnboardingView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var dataManager = DataManager()
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to Your Culinary Journey",
            description: "Discover, create, and perfect your cooking skills with our comprehensive culinary companion",
            imageName: "chef.hat",
            color: Color.tasteLogPrimary
        ),
        OnboardingPage(
            title: "Save Your Favorite Recipes",
            description: "Browse through delicious recipes and save your favorites for quick access anytime",
            imageName: "book.closed",
            color: Color.tasteLogAccent
        ),
        OnboardingPage(
            title: "Track Your Cooking Notes",
            description: "Document your culinary experiments, tips, and discoveries as you grow as a chef",
            imageName: "pencil.and.outline",
            color: Color.tasteLogSecondary
        ),
        OnboardingPage(
            title: "Perfect Your Timing",
            description: "Use built-in timers for perfect cooking results every time",
            imageName: "timer",
            color: Color.tasteLogPrimary
        )
    ]
    
    var body: some View {
        if showMainApp {
            MainTabView()
                .environmentObject(dataManager)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        } else {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Page Content
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                    
                    // Bottom Section
                    VStack(spacing: 24) {
                        // Page Indicators
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? Color.tasteLogPrimary : Color.tasteLogPrimary.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        
                        // Action Buttons
                        HStack(spacing: 16) {
                            if currentPage > 0 {
                                Button("Back") {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage -= 1
                                    }
                                }
                                .buttonStyle(TasteLogButtonStyle(isPrimary: false))
                            }
                            
                            Spacer()
                            
                            Button(currentPage == pages.count - 1 ? "Start Cooking" : "Next") {
                                if currentPage == pages.count - 1 {
                                    dataManager.completeOnboarding()
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showMainApp = true
                                    }
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage += 1
                                    }
                                }
                            }
                            .buttonStyle(TasteLogButtonStyle(isPrimary: true))
                        }
                        .padding(.horizontal, 32)
                        
                        // Skip Button
                        if currentPage < pages.count - 1 {
                            Button("Skip") {
                                dataManager.completeOnboarding()
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMainApp = true
                                }
                            }
                            .foregroundColor(Color.tasteLogText.opacity(0.6))
                            .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                page.color.opacity(0.3),
                                page.color.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
            }
            .onAppear {
                animateIcon = true
            }
            
            // Text Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.tasteLogText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateText)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.tasteLogText.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateText)
            }
            .padding(.horizontal, 32)
            .onAppear {
                animateText = true
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
