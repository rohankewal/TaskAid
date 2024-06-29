//
//  SettingsView.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresenting: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                isPresenting = false
            })
        }
    }
}
