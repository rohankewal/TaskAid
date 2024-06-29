//
//  SearchBar.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder() // Dismiss the keyboard when the search button is clicked
        }

        func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            return true // Dismiss the keyboard when the user stops using it
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search Tasks"
        searchBar.returnKeyType = .done // Set the return key type to "Done"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
