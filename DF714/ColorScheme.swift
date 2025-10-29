//
//  ColorScheme.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

extension Color {
    // Chicken Road inspired color palette
    static let tasteLogBackground = Color(red: 0.17, green: 0.11, blue: 0.11) // #2C1B1B
    static let tasteLogPrimary = Color(red: 1.0, green: 0.84, blue: 0.31) // #FFD54F
    static let tasteLogSecondary = Color(red: 1.0, green: 0.95, blue: 0.88) // #FFF3E0
    static let tasteLogAccent = Color(red: 1.0, green: 0.6, blue: 0.0) // #FF9800
    
    // Additional colors for better contrast
    static let tasteLogText = Color(red: 0.95, green: 0.95, blue: 0.95) // Light text
    static let tasteLogCardBackground = Color(red: 0.25, green: 0.18, blue: 0.18) // Slightly lighter than background
    static let tasteLogShadow = Color.black.opacity(0.3)
}

struct TasteLogButtonStyle: ButtonStyle {
    let isPrimary: Bool
    
    init(isPrimary: Bool = true) {
        self.isPrimary = isPrimary
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isPrimary ? Color.tasteLogPrimary : Color.tasteLogSecondary)
                    .shadow(color: Color.tasteLogShadow, radius: 4, x: 0, y: 2)
            )
            .foregroundColor(isPrimary ? Color.tasteLogBackground : Color.tasteLogBackground)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct TasteLogCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.tasteLogCardBackground)
                    .shadow(color: Color.tasteLogShadow, radius: 6, x: 0, y: 3)
            )
    }
}

extension View {
    func tasteLogCard() -> some View {
        self.modifier(TasteLogCardStyle())
    }
}

