//
//  UserDefaults+Extensions.swift
//  iOS18AppIdea
//
//  Created by Rohan Kewalramani on 6/19/24.
//

import Foundation

extension UserDefaults {
    func save<T: Encodable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }
}
