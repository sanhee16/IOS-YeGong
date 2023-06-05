//
//  Defaults.swift
//  YeGong
//
//  Created by sandy on 2023/06/03.
//
import Foundation

@propertyWrapper struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
        get { (UserDefaults.standard.object(forKey: self.key) as? T) ?? self.defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

class Defaults {
    @UserDefault<Bool>(key: "LAUNCH_BEFORE", defaultValue: false)
    public static var launchBefore
    
    //MARK: Setting
    /*
     1: On, 0: Off
     8자리까지 채울 수 있음!
     */
    @UserDefault<UInt8>(key: "SETTING_FLAG", defaultValue: 0)
    public static var settingFlag
    
}
