//
//  DataModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/03.
//

import Foundation
import SwiftUI

enum SettingFlag: Int {
    case EXAMPLE = 0
    //    case FILTER = 1
    //    case REVIEW = 2
    
    var option: UInt8 {
        0b1 << self.rawValue
    }
}


struct VocaCSVModel {
    var word: String
    var mean: String
    var level: Int
    var examples: [String]
    
    init(_ values: [String]) {
        self.word = values[0]
        self.mean = values[1]
        self.level = Int(values[2]) ?? 1
        self.examples = values[3].removingRegexMatches(pattern: "\\r").components(separatedBy: "^^")
    }
}
