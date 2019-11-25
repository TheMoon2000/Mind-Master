//
//  FallingColor.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

class FallingColor: Hashable {
    let fallRate: Double
    let trackIndex: Int
    let startTime: TimeInterval
    
    var fallPercentage: Double {
        return (Date.timeIntervalSinceReferenceDate - startTime) / fallRate
    }
    
    init(index: Int, fallRate: Double) {
        self.trackIndex = index
        self.fallRate = fallRate
        startTime = Date.timeIntervalSinceReferenceDate
    }
    
    static func ==(lhs: FallingColor, rhs: FallingColor) -> Bool {
        return lhs.startTime == rhs.startTime && lhs.trackIndex == rhs.trackIndex
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(startTime)
        hasher.combine(trackIndex)
    }
}
