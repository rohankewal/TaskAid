//
//  AddTaskView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Binding var isPresenting: Bool
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var time: Date? = nil
    @State private var tags: [Tag] = []
    @State private var description: String = ""
    @State private var recurrence: Recurrence = .none
    @State private var priority: Priority = .medium
    @State private var attachments: [Attachment] = []
    @State private var subtasks: [Subtask] = []

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
            .navigationTitle("Add Task")
            .navigationBarItems(leading: Button("Cancel") {
                isPresenting = false
            }, trailing: Button("Save") {
                viewModel.addItem(title: title, date: date, time: time, tags: tags, description: description, recurrence: recurrence, priority: priority, attachments: attachments, subtasks: subtasks)
                isPresenting = false
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
    AddTaskView(viewModel: TodoViewModel(), isPresenting: .constant(true))
}
