//
//  Color+Codable.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import SwiftUI

// Color extension to conform to Codable
extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let alpha = try container.decode(Double.self, forKey: .alpha)
        self = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode(Double(red), forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue), forKey: .blue)
        try container.encode(Double(alpha), forKey: .alpha)
    }
}
