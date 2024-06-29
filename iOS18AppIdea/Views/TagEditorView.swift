//
//  TagEditorView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/23/24.
//

import SwiftUI

struct TagEditorView: View {
    var tag: Tag
    @Binding var tags: [Tag]
    @State private var isEditing: Bool = false
    @State private var editedTagName: String = ""
    @State private var editedTagColor: Color = .blue

    var body: some View {
        HStack {
            if isEditing {
                TextField("Tag name", text: $editedTagName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                ColorPicker("", selection: $editedTagColor)
                    .labelsHidden()
                Button(action: {
                    saveChanges()
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                Button(action: {
                    cancelEditing()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            } else {
                Text(tag.name)
                    .padding(4)
                    .background(tag.color)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                Button(action: {
                    startEditing()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                }
                Button(action: {
                    deleteTag()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.trailing, 4)
    }

    private func startEditing() {
        isEditing = true
        editedTagName = tag.name
        editedTagColor = tag.color
    }

    private func saveChanges() {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags[index].name = editedTagName
            tags[index].color = editedTagColor
        }
        isEditing = false
    }

    private func cancelEditing() {
        isEditing = false
    }

    private func deleteTag() {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags.remove(at: index)
        }
    }
}

#Preview {
    TagEditorView(tag: Tag(name: "Sample", color: .blue), tags: .constant([Tag(name: "Sample", color: .blue)]))
}
