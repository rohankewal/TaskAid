//
//  TodoItem.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

enum Recurrence: String, Codable, CaseIterable, Identifiable {
    case none, daily, weekly, monthly, custom
    var id: String { self.rawValue }
}

enum Priority: String, CaseIterable, Identifiable, Codable {
    case high, medium, low

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}

struct Attachment: Identifiable, Codable {
    var id = UUID()
    var imageData: Data
}

struct Subtask: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct TodoItem: Identifiable, Codable {
    var id = UUID()
        var title: String
        var date: Date
        var time: Date?
        var tags: [Tag]
        var description: String
        var recurrence: Recurrence
        var priority: Priority
        var attachments: [Attachment]
        var subtasks: [Subtask]
        var isCompleted: Bool = false
}
