//
//  AddEditNoteView.swift
//  DF714
//
//  Created by IGOR on 09/10/2025.
//

import SwiftUI

struct AddEditNoteView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    let note: CulinaryNote?
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory: CulinaryNote.NoteCategory = .tip
    @State private var showingCategoryPicker = false
    
    private var isEditing: Bool {
        note != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tasteLogBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Title")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.tasteLogText)
                            
                            TextField("Enter note title...", text: $title)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.tasteLogText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.tasteLogCardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.tasteLogPrimary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        // Category Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.tasteLogText)
                            
                            Button(action: {
                                showingCategoryPicker = true
                            }) {
                                HStack {
                                    Text(selectedCategory.rawValue)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.tasteLogText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.tasteLogText.opacity(0.6))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.tasteLogCardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.tasteLogPrimary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Content Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Content")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.tasteLogText)
                            
                            ZStack(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("Share your cooking discoveries, tips, experiments, and ideas...")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.tasteLogText.opacity(0.5))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                
                                TextEditor(text: $content)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color.tasteLogText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                            }
                            .frame(minHeight: 200)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.tasteLogCardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.tasteLogPrimary.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Save Button
                        Button(action: saveNote) {
                            HStack {
                                Spacer()
                                Text(isEditing ? "Update Note" : "Save Note")
                                    .font(.system(size: 16, weight: .semibold))
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(canSave ? Color.tasteLogPrimary : Color.tasteLogPrimary.opacity(0.5))
                            )
                            .foregroundColor(Color.tasteLogBackground)
                        }
                        .disabled(!canSave)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Edit Note" : "New Note")
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
        .onAppear {
            if let note = note {
                title = note.title
                content = note.content
                selectedCategory = note.category
            }
        }
        .actionSheet(isPresented: $showingCategoryPicker) {
            ActionSheet(
                title: Text("Select Category"),
                buttons: CulinaryNote.NoteCategory.allCases.map { category in
                    .default(Text(category.rawValue)) {
                        selectedCategory = category
                    }
                } + [.cancel()]
            )
        }
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty && !trimmedContent.isEmpty else { return }
        
        if let existingNote = note {
            // Update existing note
            var updatedNote = existingNote
            updatedNote.title = trimmedTitle
            updatedNote.content = trimmedContent
            updatedNote.dateModified = Date()
            updatedNote.category = selectedCategory
            dataManager.updateNote(updatedNote)
        } else {
            // Create new note
            let newNote = CulinaryNote(
                title: trimmedTitle,
                content: trimmedContent,
                dateCreated: Date(),
                dateModified: Date(),
                category: selectedCategory
            )
            dataManager.addNote(newNote)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditNoteView(note: nil)
        .environmentObject(DataManager())
}
