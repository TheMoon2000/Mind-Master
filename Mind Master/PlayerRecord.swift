//
//  PlayerRecord.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlayerRecord: NSObject {
    
    static var current = PlayerRecord()
    
    // Reaction time
    var reaction: Double? { didSet { save() } }
    
    var gridHelp = true { didSet { save() } }
    var gridIterations: Int = 10 { didSet { save() } }
    var gridRecord = [Int: Double]() { didSet { save() } }
    
    // Color dodge
    var trackNumber = 4 { didSet { save() } }
    var dodgeHighscore = 0 { didSet { save() } }
    
    // Memory challenge
    var memoryMaxLength: Int? { didSet { save() } }
    var memoryItemCount = 8 { didSet { save() } }
    var delayPerItem = 1.0 { didSet { save() } }
    
    /// The segment index of the memory test type.
    var memoryTestType: RecallType = .digits { didSet { save() } }
    
    override init() {
        reaction = nil
        memoryMaxLength = nil
    }
    
    init(data: JSON) {
        let dictionary = data.dictionaryValue
        
        reaction = dictionary["reaction"]?.double
        
        // Grid
        gridHelp = dictionary["showGridHelpScreen"]?.bool ?? true
        gridIterations = dictionary["gridIterations"]?.int ?? 10
        if let record = dictionary["grid"]?.dictionaryObject as? [String: Double] {
            for (length, duration) in record {
                gridRecord[Int(length) ?? 0] = duration
            }
        }
        
        memoryMaxLength = dictionary["memoryMaxLength"]?.int
        memoryItemCount = dictionary["memoryItemCount"]?.int ?? 8
        delayPerItem = dictionary["memoryDelay"]?.double ?? 1.0
        memoryTestType = .init(rawValue: dictionary["memoryTestType"]?.int ?? 1)
    }
    
    var encodedJSON: JSON {
        var json = JSON()
        json.dictionaryObject?["reaction"] = reaction
        
        json.dictionaryObject?["gridIterations"] = gridIterations
        json.dictionaryObject?["showGridHelpScreen"] = gridHelp
        
        json.dictionaryObject?["memoryMaxLength"] = memoryMaxLength
        json.dictionaryObject?["memoryItemCount"] = memoryItemCount
        json.dictionaryObject?["memoryDelay"] = delayPerItem
        json.dictionaryObject?["memoryTestType"] = memoryTestType.rawValue
        
        var serializedRecord = [String: Double]()
        for (length, duration) in gridRecord {
            serializedRecord[String(length)] = duration
        }
        
        json.dictionaryObject?["grid"] = serializedRecord
        
        return json
    }
    
    
    /// Recover any data from the cache.
    static func read() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: SAVE_PATH.path) as? Data, let decrypted = NSData(data: data).aes256Decrypt(withKey: AES_KEY), let json = try? JSON(data: decrypted) {
            PlayerRecord.current = PlayerRecord(data: json)
        }
    }
    
    /// Write to cache.
    func save() {
        
        if PlayerRecord.current != self { return }
        
        let encrypted = NSData(data: try! encodedJSON.rawData()).aes256Encrypt(withKey: AES_KEY)!
        NSKeyedArchiver.archiveRootObject(encrypted, toFile: SAVE_PATH.path)
    }
}
