//
//  TagsInputView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/23/24.
//

import SwiftUI

struct TagsInputView: View {
    @Binding var tags: [Tag]
    @State private var newTagName: String = ""
    @State private var newTagColor: Color = .blue

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("New tag name", text: $newTagName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                ColorPicker("", selection: $newTagColor)
                    .labelsHidden()
                Button(action: addTag) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
                .disabled(newTagName.isEmpty)
            }
            .padding(.bottom, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tags) { tag in
                        HStack {
                            Text(tag.name)
                                .padding(4)
                                .background(tag.color)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                            Button(action: {
                                removeTag(tag)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 4)
                    }
                }
            }
        }
        .padding()
    }

    private func addTag() {
        let newTag = Tag(name: newTagName, color: newTagColor)
        tags.append(newTag)
        newTagName = ""
        newTagColor = .blue
    }

    private func removeTag(_ tag: Tag) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags.remove(at: index)
        }
    }
}

#Preview {
    TagsInputView(tags: .constant([Tag(name: "Work", color: .blue)]))
}
