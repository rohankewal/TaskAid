//
//  TaskDetailView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/23/24.
//

import SwiftUI

struct TaskDetailView: View {
    let item: TodoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(item.title)
                .font(.title)
                .padding(.bottom, 8)
            
            HStack {
                Text("Due Date: \(item.date, formatter: dateFormatter)")
                if let time = item.time {
                    Text("at \(time, formatter: timeFormatter)")
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            if !item.tags.isEmpty {
                HStack {
                    ForEach(item.tags) { tag in
                        Text(tag.name)
                            .padding(4)
                            .background(tag.color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
            }
            
            if !item.description.isEmpty {
                Text("Description")
                    .font(.headline)
                Text(item.description)
            }

            Text("Priority")
                .font(.headline)
            Text(item.priority.rawValue.capitalized)
                .foregroundColor(item.priority.color)

            if !item.subtasks.isEmpty {
                Text("Subtasks")
                    .font(.headline)
                ForEach(item.subtasks) { subtask in
                    HStack {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                        Text(subtask.title)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Task Details")
    }
}

#Preview {
    TaskDetailView(item: TodoItem(id: UUID(), title: "Sample Task", date: Date(), time: Date(), tags: [Tag(name: "Work", color: .blue)], description: "This is a sample task description.", recurrence: .daily, priority: .high, attachments: [], subtasks: [Subtask(title: "Subtask 1", isCompleted: false)]))
}
