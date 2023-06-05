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

