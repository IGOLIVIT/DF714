//
//  NotesView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddNote = false
    @State private var selectedNote: CulinaryNote? = nil
    @State private var showingEditNote = false
    @State private var searchText = ""
    @State private var selectedCategory: CulinaryNote.NoteCategory? = nil
    
    var filteredNotes: [CulinaryNote] {
        var notes = dataManager.notes
        
        if !searchText.isEmpty {
            notes = notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            notes = notes.filter { $0.category == category }
        }
        
        return notes.sorted { $0.dateModified > $1.dateModified }
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
                                Text("Culinary Notes")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.tasteLogText)
                                
                                Text("Your cooking discoveries")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color.tasteLogText.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddNote = true
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
                            
                            TextField("Search notes...", text: $searchText)
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
                                
                                ForEach(CulinaryNote.NoteCategory.allCases, id: \.self) { category in
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
                    
                    // Notes List
                    if filteredNotes.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            
                            Image(systemName: "note.text")
                                .font(.system(size: 60))
                                .foregroundColor(Color.tasteLogText.opacity(0.3))
                            
                            Text(searchText.isEmpty ? "No notes yet" : "No notes found")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.tasteLogText.opacity(0.6))
                            
                            Text(searchText.isEmpty ? "Tap + to create your first cooking note" : "Try adjusting your search or filters")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color.tasteLogText.opacity(0.5))
                                .multilineTextAlignment(.center)
                            
                            if searchText.isEmpty {
                                Button("Add Note") {
                                    showingAddNote = true
                                }
                                .buttonStyle(TasteLogButtonStyle(isPrimary: true))
                                .padding(.top, 8)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredNotes) { note in
                                    NoteCard(note: note) {
                                        selectedNote = note
                                        showingEditNote = true
                                    } deleteAction: {
                                        dataManager.deleteNote(note)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddNote) {
            AddEditNoteView(note: nil)
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingEditNote) {
            if let note = selectedNote {
                AddEditNoteView(note: note)
                    .environmentObject(dataManager)
            }
        }
    }
}

struct NoteCard: View {
    let note: CulinaryNote
    let editAction: () -> Void
    let deleteAction: () -> Void
    @State private var showingDeleteAlert = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.tasteLogText)
                        .multilineTextAlignment(.leading)
                    
                    Text(note.content)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.tasteLogText.opacity(0.8))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Menu {
                    Button(action: editAction) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .foregroundColor(Color.tasteLogText.opacity(0.6))
                }
            }
            
            HStack {
                // Category Badge
                Text(note.category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.tasteLogBackground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(categoryColor(note.category))
                    )
                
                Spacer()
                
                Text(dateFormatter.string(from: note.dateModified))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.tasteLogText.opacity(0.6))
            }
        }
        .padding(16)
        .tasteLogCard()
        .onTapGesture {
            editAction()
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAction()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
    
    private func categoryColor(_ category: CulinaryNote.NoteCategory) -> Color {
        switch category {
        case .experiment:
            return Color.purple
        case .tip:
            return Color.blue
        case .review:
            return Color.green
        case .idea:
            return Color.orange
        case .technique:
            return Color.red
        }
    }
}

#Preview {
    NotesView()
        .environmentObject(DataManager())
}
