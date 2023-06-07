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
    
    // 마지막 학습한 idx
    @UserDefault<Int>(key: "BOOKMARK_IDX", defaultValue: 0)
    public static var bookmarkIdx
    
    // 메인에 띄울 레벨 선택 - 복수선택 가넝한
    @UserDefault<[Int]>(key: "STUDY_FILTER", defaultValue: [1,2,3])
    public static var studyFilter
    
    @UserDefault<Bool>(key: "IS_VISIBLE_WORD", defaultValue: true)
    public static var isVisibleWord
    
    @UserDefault<Bool>(key: "IS_VISIBLE_MEAN", defaultValue: true)
    public static var isVisibleMean
    
    // 0: 전체. 1: 북마크
    @UserDefault<Int>(key: "STUDY_MODE", defaultValue: 0)
    public static var studyMode
    
    
    //MARK: Setting
    /*
     1: On, 0: Off
     8자리까지 채울 수 있음!
     */
    @UserDefault<UInt8>(key: "SETTING_FLAG", defaultValue: 0)
    public static var settingFlag
    
}
