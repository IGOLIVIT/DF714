//
//  TimerDetailView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI
import AVFoundation

struct TimerDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    let duration: Int
    let recipeName: String
    
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var timer: Timer?
    @State private var showingCompletionAlert = false
    @State private var animationScale: CGFloat = 1.0
    
    init(duration: Int, recipeName: String) {
        self.duration = duration
        self.recipeName = recipeName
        self._timeRemaining = State(initialValue: duration)
    }
    
    private var progress: Double {
        guard duration > 0 else { return 0 }
        return Double(duration - timeRemaining) / Double(duration)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Recipe Name
                    Text(recipeName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color.tasteLogText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Timer Circle
                    ZStack {
                        // Background Circle
                        Circle()
                            .stroke(Color.tasteLogCardBackground, lineWidth: 8)
                            .frame(width: 250, height: 250)
                        
                        // Progress Circle
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                Color.tasteLogPrimary,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 250, height: 250)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progress)
                        
                        // Time Display
                        VStack(spacing: 8) {
                            Text(formatTime(timeRemaining))
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.tasteLogText)
                                .scaleEffect(animationScale)
                                .animation(.easeInOut(duration: 0.5), value: animationScale)
                            
                            Text(timeRemaining > 0 ? "remaining" : "finished")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.tasteLogText.opacity(0.7))
                        }
                    }
                    
                    // Control Buttons
                    HStack(spacing: 20) {
                        // Reset Button
                        Button(action: resetTimer) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.tasteLogText)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(Color.tasteLogCardBackground)
                                        .shadow(color: Color.tasteLogShadow, radius: 4, x: 0, y: 2)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Play/Pause Button
                        Button(action: toggleTimer) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(Color.tasteLogBackground)
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .fill(Color.tasteLogPrimary)
                                        .shadow(color: Color.tasteLogShadow, radius: 6, x: 0, y: 3)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(isRunning ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isRunning)
                        
                        // Stop Button
                        Button(action: stopTimer) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.tasteLogText)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(Color.tasteLogCardBackground)
                                        .shadow(color: Color.tasteLogShadow, radius: 4, x: 0, y: 2)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Quick Time Adjustments
                    if !isRunning || isPaused {
                        VStack(spacing: 12) {
                            Text("Quick Adjust")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color.tasteLogText.opacity(0.7))
                            
                            HStack(spacing: 16) {
                                QuickAdjustButton(title: "-1 min", action: { adjustTime(-60) })
                                QuickAdjustButton(title: "+1 min", action: { adjustTime(60) })
                                QuickAdjustButton(title: "+5 min", action: { adjustTime(300) })
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        stopTimer()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.tasteLogPrimary)
                }
            }
        }
        .onDisappear {
            stopTimer()
        }
        .alert("Timer Finished!", isPresented: $showingCompletionAlert) {
            Button("OK") {
                resetTimer()
            }
        } message: {
            Text("Your \(recipeName) timer has finished!")
        }
    }
    
    private func toggleTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        isRunning = true
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                
                // Pulse animation every second
                withAnimation(.easeInOut(duration: 0.1)) {
                    animationScale = 1.05
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        animationScale = 1.0
                    }
                }
            } else {
                // Timer finished
                stopTimer()
                showingCompletionAlert = true
                playCompletionSound()
            }
        }
    }
    
    private func pauseTimer() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    private func stopTimer() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        stopTimer()
        timeRemaining = duration
    }
    
    private func adjustTime(_ seconds: Int) {
        timeRemaining = max(0, timeRemaining + seconds)
    }
    
    private func playCompletionSound() {
        AudioServicesPlaySystemSound(1005) // System sound for completion
    }
}

struct QuickAdjustButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.tasteLogText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.tasteLogCardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomTimerView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var hours = 0
    @State private var minutes = 5
    @State private var seconds = 0
    @State private var timerName = ""
    @State private var showingTimer = false
    
    private var totalSeconds: Int {
        hours * 3600 + minutes * 60 + seconds
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Custom Timer")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.tasteLogText)
                    
                    // Timer Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Timer Name (Optional)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.tasteLogText)
                        
                        TextField("e.g., Marinating Chicken", text: $timerName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 16))
                            .foregroundColor(Color.tasteLogText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.tasteLogCardBackground)
                            )
                    }
                    .padding(.horizontal, 20)
                    
                    // Time Pickers
                    VStack(spacing: 20) {
                        Text("Set Duration")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.tasteLogText)
                        
                        HStack(spacing: 20) {
                            TimePickerColumn(title: "Hours", value: $hours, range: 0...23)
                            TimePickerColumn(title: "Minutes", value: $minutes, range: 0...59)
                            TimePickerColumn(title: "Seconds", value: $seconds, range: 0...59)
                        }
                    }
                    
                    // Start Button
                    Button(action: {
                        if totalSeconds > 0 {
                            showingTimer = true
                            dataManager.incrementTimersUsed()
                        }
                    }) {
                        Text("Start Timer")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.tasteLogBackground)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(totalSeconds > 0 ? Color.tasteLogPrimary : Color.tasteLogPrimary.opacity(0.5))
                            )
                    }
                    .disabled(totalSeconds == 0)
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Custom Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.tasteLogPrimary)
                }
            }
        }
        .sheet(isPresented: $showingTimer) {
            TimerDetailView(
                duration: totalSeconds,
                recipeName: timerName.isEmpty ? "Custom Timer" : timerName
            )
            .environmentObject(dataManager)
            .onDisappear {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct TimePickerColumn: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.tasteLogText.opacity(0.7))
            
            Picker(title, selection: $value) {
                ForEach(range, id: \.self) { number in
                    Text(String(format: "%02d", number))
                        .foregroundColor(Color.tasteLogText)
                        .tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 80, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.tasteLogCardBackground)
            )
        }
    }
}

#Preview {
    TimerDetailView(duration: 300, recipeName: "Soft Boiled Eggs")
        .environmentObject(DataManager())
}

