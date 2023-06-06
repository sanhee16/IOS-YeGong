//
//  RealmDataModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/05.
//

import Foundation
import Realm
import RealmSwift


class Voca: Object {
    @objc dynamic var word: String
    @objc dynamic var mean: String
    @objc dynamic var level: Int
    dynamic var examples: List<String>
    
    dynamic var bookmarkTime: Int? //epoch
    dynamic var studyTime: Int? //epoch
    @objc dynamic var wrongCnt: Int
    
    override required init() {
        self.word = ""
        self.mean = ""
        self.level = 1
        self.examples = List<String>()
        
        self.bookmarkTime = nil
        self.studyTime = nil
        self.wrongCnt = 0
    }
    
    init(_ item: VocaCSVModel) {
        let list = List<String>()
        item.examples.forEach {i in
            list.append(i)
        }
        self.word = item.word
        self.mean = item.mean
        self.level = item.level
        self.examples = list
        
        self.bookmarkTime = nil
        self.studyTime = nil
        self.wrongCnt = 0
        super.init()
    }
}
