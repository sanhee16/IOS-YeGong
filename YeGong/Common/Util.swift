//
//  Util.swift
//  YeGong
//
//  Created by sandy on 2023/06/03.
//

import Foundation
import SwiftUI
//import RealmSwift

enum PermissionStatus {
    case allow
    case notYet
    case notAllow
    case unknown
}

class Util {
    static func safeAreaInsets() -> UIEdgeInsets? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)?.safeAreaInsets
    }
    
    static func safeBottom() -> CGFloat {
        return safeAreaInsets()?.bottom ?? 0
    }
    
    static func safeTop() -> CGFloat {
        return safeAreaInsets()?.top ?? 0
    }
    
    static func getSettingStatus(_ flag: SettingFlag) -> Bool {
        let settingFlag: UInt8 = Defaults.settingFlag
        return (settingFlag & flag.option) > 0
    }
    
    // bit flag: https://boycoding.tistory.com/164
    static func setSettingStatus(_ flag: SettingFlag, isOn: Bool) {
        let settingFlag: UInt8 = Defaults.settingFlag
        let res: UInt8 = isOn ? (settingFlag | flag.option) : (settingFlag & (~flag.option))
        Defaults.settingFlag = res
    }
    
    static func currentTime() -> Int {
        return Int(NSDate().timeIntervalSince1970)
    }
}

class UserLocale {
    static func currentLanguage() -> String? {
        return Locale.current.languageCode
    }
    
    static func currentRegion() -> String? {
        return Locale.current.regionCode
    }
    
    static func identifier() -> String {
        return Locale.current.identifier
    }
}
