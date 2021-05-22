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
    
    var smallerIndex: Int { min(indexA, indexB) }
    var largerIndex: Int { max(indexA, indexB) }
    
    init(_ indexA: Int, _ indexB: Int) {
        self.indexA = indexA
        self.indexB = indexB
    }
    
    static func ==(lhs: Connection, rhs: Connection) -> Bool {
        return (lhs.smallerIndex, lhs.largerIndex) == (rhs.smallerIndex, rhs.largerIndex)
    }
    
    // Note that both directions of directed edge have the same hash value.
    func hash(into hasher: inout Hasher) {
        hasher.combine(smallerIndex)
        hasher.combine(largerIndex)
    }
    
    var description: String {
        return "<\(indexA) -> \(indexB)>"
    }
}
