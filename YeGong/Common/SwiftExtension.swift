//
//  SwiftExtension.swift
//  YeGong
//
//  Created by sandy on 2023/06/03.
//
import SwiftUI
import Combine

extension Int {
    func getDate() -> String {
        let timeToDate = Date(timeIntervalSince1970: Double(self)) // 2021-10-13 17:16:15 +0000
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "yyyy/MM/dd"
//        date.dateFormat = "MM월dd일 HH:mm"
        
        let kr = date.string(from: timeToDate)
        return kr
    }
    
    func levelBadgeType() -> LevelBadgeType {
        return LevelBadgeType(rawValue: self) ?? .lv1
    }
    
    func getVocaType() -> VocaType? {
        return VocaType(rawValue: self)
    }
}


extension Publisher {
    func run(in set: inout Set<AnyCancellable>, next: ((Self.Output) -> Void)? = nil, err errorListener: ((Error) -> Void)? = nil, complete: (() -> Void)? = nil) {
        self.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(err) = completion {
                    errorListener?(err)
                }
                complete?()
            } receiveValue: { value in
                next?(value)
            }
            .store(in: &set)
    }
}

extension String {
    func localized(_ args: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: args)
    }
    
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch { return self }
    }
}
