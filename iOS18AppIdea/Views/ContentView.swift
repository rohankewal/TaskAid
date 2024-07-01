//
//  ContentView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/12/24.
//

import SwiftUI
import EventKit

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var isPresentingAddTaskView = false
    @State private var isPresentingSettingsView = false
    @State private var renamingItem: TodoItem? = nil
    @State private var newTitle: String = ""
    @State private var newDate: Date = Date()
    @State private var newTime: Date? = nil
    @State private var newTags: [Tag] = []
    @State private var newDescription: String = ""
    @State private var newRecurrence: Recurrence = .none
    @State private var newPriority: Priority = .medium
    @State private var newAttachments: [Attachment] = []
    @State private var newSubtasks: [Subtask] = []
    @State private var searchText = ""
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
                List {
                    ForEach(viewModel.items.filter { searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) }) { item in
                        NavigationLink(destination: TaskDetailView(item: item)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.priority.rawValue.capitalized)
                                    .foregroundColor(item.priority.color)
                                    .font(.headline)
                                
                                HStack {
                                    ForEach(item.tags) { tag in
                                        TagEditorView(tag: tag, tags: $newTags)
                                    }
                                }
                                
                                HStack {
                                    Text(item.title)
                                        .strikethrough(item.isCompleted)
                                        .foregroundColor(item.isCompleted ? .gray : .primary)
                                        .accessibilityLabel(item.isCompleted ? "Completed: \(item.title)" : item.title)
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        Button(action: {
                                            viewModel.toggleCompletion(for: item)
                                        }) {
                                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                                .font(.title2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        Spacer()
                                    }
                                }
                                
                                Text("\(item.date, formatter: dateFormatter) • \(item.time != nil ? timeFormatter.string(from: item.time!) : "")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .accessibilityLabel("Due date and time: \(dateFormatter.string(from: item.date)) \(item.time != nil ? timeFormatter.string(from: item.time!) : "")")
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                                    viewModel.items.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                renamingItem = item
                                newTitle = item.title
                                newDate = item.date
                                newTime = item.time
                                newTags = item.tags
                                newDescription = item.description
                                newRecurrence = item.recurrence
                                newPriority = item.priority
                                newAttachments = item.attachments
                                newSubtasks = item.subtasks
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                            Button {
                                addEventToCalendar(title: item.title, date: item.date, time: item.time)
                            } label: {
                                Label("Add to Calendar", systemImage: "calendar")
                            }
                            Button {
                                shareTask(item)
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("To-Do List")
            .navigationBarItems(
                leading: Button(action: {
                    isPresentingSettingsView = true
                }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                },
                trailing: Button(action: {
                    isPresentingAddTaskView = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            )
            .sheet(item: $renamingItem) { item in
                TaskEditView(
                    title: $newTitle,
                    date: $newDate,
                    time: $newTime,
                    tags: $newTags,
                    description: $newDescription,
                    recurrence: $newRecurrence,
                    priority: $newPriority,
                    attachments: $newAttachments,
                    subtasks: $newSubtasks,
                    onSave: { title, date, time, tags, description, recurrence, priority, attachments, subtasks in
                        viewModel.renameItem(item, newTitle: title, newDate: date, newTime: time, newTags: tags, newDescription: description, newRecurrence: recurrence, newPriority: priority, newAttachments: attachments, newSubtasks: subtasks)
                        renamingItem = nil
                    }
                )
            }
            .sheet(isPresented: $isPresentingAddTaskView) {
                AddTaskView(viewModel: viewModel, isPresenting: $isPresentingAddTaskView)
            }
            .sheet(isPresented: $isPresentingSettingsView) {
                SettingsView(isPresenting: $isPresentingSettingsView)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private func addEventToCalendar(title: String, date: Date, time: Date?) {
        let eventStore = EKEventStore()

        eventStore.requestWriteOnlyAccessToEvents { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting access to event store: \(error.localizedDescription)")
                    return
                }

                guard granted else {
                    print("Access to event store not granted")
                    return
                }

                let event = EKEvent(eventStore: eventStore)
                event.title = title
                let startDate = time ?? date
                event.startDate = startDate
                event.endDate = startDate.addingTimeInterval(60 * 60) // 1 hour duration
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Event added to calendar")
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            }
        }
    }

    private func shareTask(_ task: TodoItem) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [richText(for: task)], applicationActivities: nil)

            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                scene.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
}

func richText(for task: TodoItem) -> String {
    return """
    Task: \(task.title)
    Due: \(dateFormatter.string(from: task.date)) \(task.time != nil ? timeFormatter.string(from: task.time!) : "")
    Description: \(task.description)
    """
}
