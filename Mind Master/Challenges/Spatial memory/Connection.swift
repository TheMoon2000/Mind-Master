//
//  Connection.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2021/5/18.
//  Copyright © 2021 Calpha Dev. All rights reserved.
//

import Foundation

/// An internal class that represents a connection between two dots on a ring.
struct Connection: Hashable, Equatable, CustomStringConvertible {
    
    /// The first point
    let indexA: Int
    let indexB: Int
    
    init(_ indexA: Int, _ indexB: Int) {
        self.indexA = min(indexA, indexB)
        self.indexB = max(indexA, indexB)
    }
    
    static func ==(lhs: Connection, rhs: Connection) -> Bool {
        return lhs.indexA == rhs.indexA && lhs.indexB == rhs.indexB
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(indexA)
        hasher.combine(indexB)
    }
    
    var description: String {
        return "<\(indexA) - \(indexB)>"
    }
}
