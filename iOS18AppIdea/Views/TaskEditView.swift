//
//  TaskEditView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

struct TaskEditView: View {
    @Binding var title: String
    @Binding var date: Date
    @Binding var time: Date?
    @Binding var tags: [Tag]
    @Binding var description: String
    @Binding var recurrence: Recurrence
    @Binding var priority: Priority
    @Binding var attachments: [Attachment]
    @Binding var subtasks: [Subtask]
    var onSave: (String, Date, Date?, [Tag], String, Recurrence, Priority, [Attachment], [Subtask]) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Time", selection: Binding($time, replacingNilWith: { Date() }), displayedComponents: .hourAndMinute)
                    TagsInputView(tags: $tags)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 150)
                }
                Section(header: Text("Recurrence")) {
                    Picker("Recurrence", selection: $recurrence) {
                        ForEach(Recurrence.allCases) { recurrence in
                            Text(recurrence.rawValue.capitalized).tag(recurrence)
                        }
                    }
                }
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                                .foregroundColor(priority.color)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Attachments")) {
                    Button(action: addAttachment) {
                        Text("Add Photo")
                    }
                    ForEach(attachments) { attachment in
                        if let image = UIImage(data: attachment.imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                    }
                }
                Section(header: Text("Subtasks")) {
                    ForEach($subtasks) { $subtask in
                        HStack {
                            TextField("Subtask", text: $subtask.title)
                            Spacer()
                            Button(action: {
                                subtask.isCompleted.toggle()
                            }) {
                                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                        }
                    }
                    Button(action: addSubtask) {
                        Text("Add Subtask")
                    }
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarItems(leading: Button("Cancel") {
                onSave(title, date, time, tags, description, recurrence, priority, attachments, subtasks)
            }, trailing: Button("Save") {
                onSave(title, date, time, tags, description, recurrence, priority, attachments, subtasks)
            })
            .sheet(isPresented: $isShowingImagePicker, content: {
                ImagePicker(selectedImage: $selectedImage, isPresented: $isShowingImagePicker)
            })
        }
    }

    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?

    private func addAttachment() {
        isShowingImagePicker = true
    }

    private func addSubtask() {
        subtasks.append(Subtask(title: ""))
    }
}

#Preview {
    TaskEditView(title: .constant("Sample Task"), date: .constant(Date()), time: .constant(Date()), tags: .constant([Tag(name: "Work", color: .blue)]), description: .constant("This is a sample task description."), recurrence: .constant(.daily), priority: .constant(.high), attachments: .constant([]), subtasks: .constant([])) { _, _, _, _, _, _, _, _, _ in }
}
