//
//  WordLevelBadge.swift
//  YeGong
//
//  Created by sandy on 2023/06/06.
//

import SwiftUI

enum LevelBadgeType: Int {
    case lv1 = 1
    case lv2 = 2
    case lv3 = 3
    
    var text: String {
        switch self {
        case .lv1: return "1"
        case .lv2: return "2"
        case .lv3: return "3"
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .lv1: return UIColor(hex: "#6FB01B")
        case .lv2: return UIColor(hex: "#2D69C2")
        case .lv3: return UIColor(hex: "#C12323")
        }
    }
    
    var color: Color {
        switch self {
        case .lv1: return Color(hex: "#6FB01B")
        case .lv2: return Color(hex: "#2D69C2")
        case .lv3: return Color(hex: "#C12323")
        }
    }
}

struct WordLevelBadge: View {
    let type: LevelBadgeType
    var body: some View {
        Text(type.text)
            .font(.kr9r)
            .foregroundColor(.white)
            .padding(4)
            .background(
                Circle()
                    .foregroundColor(type.color)
            )
            .opacity(0.8)
    }
}
