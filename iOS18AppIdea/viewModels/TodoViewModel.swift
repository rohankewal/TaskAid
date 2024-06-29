//
//  TodoViewModel.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    @Published var allTags: [Tag] = []

    func addItem(title: String, date: Date, time: Date?, tags: [Tag], description: String, recurrence: Recurrence, priority: Priority, attachments: [Attachment], subtasks: [Subtask]) {
        let newItem = TodoItem(title: title, date: date, time: time, tags: tags, description: description, recurrence: recurrence, priority: priority, attachments: attachments, subtasks: subtasks)
        items.append(newItem)
    }

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func toggleCompletion(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }

    func renameItem(_ item: TodoItem, newTitle: String, newDate: Date, newTime: Date?, newTags: [Tag], newDescription: String, newRecurrence: Recurrence, newPriority: Priority, newAttachments: [Attachment], newSubtasks: [Subtask]) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].title = newTitle
            items[index].date = newDate
            items[index].time = newTime
            items[index].tags = newTags
            items[index].description = newDescription
            items[index].recurrence = newRecurrence
            items[index].priority = newPriority
            items[index].attachments = newAttachments
            items[index].subtasks = newSubtasks
        }
    }
}
