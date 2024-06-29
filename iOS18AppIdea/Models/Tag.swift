//
//  Tag.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

struct Tag: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var color: Color
}
