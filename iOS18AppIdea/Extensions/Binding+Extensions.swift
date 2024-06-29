//
//  Binding+Extensions.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/20/24.
//

import SwiftUI

extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith nilReplacement: @escaping @Sendable () -> Value) {
        self.init(
            get: { source.wrappedValue ?? nilReplacement() },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

// Usage example:
extension Binding where Value: Sendable {
    init(_ source: Binding<Value?>, replacingNilWith nilReplacement: Value) {
        self.init(
            get: { source.wrappedValue ?? nilReplacement },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}
