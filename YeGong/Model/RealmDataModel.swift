//
//  RealmDataModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/05.
//

import Foundation
import Realm
import RealmSwift

class R {
    static let realm: Realm = try! Realm()
}

class VocaGroup: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var text: String
    @Persisted var isEditable: Bool
    @Persisted var isVisible: Bool
    @Persisted var note: String
    
    convenience init(_ text: String, isEditable: Bool) {
        self.init()
        self.text = text
        self.isEditable = isEditable
        self.isVisible = true
        self.note = ""
    }
}

class Voca: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var word: String
    @Persisted var mean: String
    @Persisted var level: Int?
    @Persisted var examples: List<String>
    @Persisted var starTime: Int? //epoch
    @Persisted var studyTime: Int? //epoch
    @Persisted var wrongCnt: Int
    @Persisted var groupId: ObjectId?
    @Persisted var note: String
    
    convenience init(_ item: VocaCSVModel, groupId: ObjectId? = nil) {
        self.init()
        let list = List<String>()
        item.examples.forEach { i in
            list.append(i)
        }
        self.word = item.word
        self.mean = item.mean
        self.level = item.level
        self.examples = list
        
        self.starTime = nil
        self.studyTime = nil
        self.wrongCnt = 0
        self.groupId = groupId
        self.note = ""
    }
    
    convenience init(_ word: String, mean: String, level: Int?, examples: List<String>, note: String, groupId: ObjectId) {
        self.init()
        self.word = word
        self.mean = mean
        self.level = level
        self.examples = examples
        self.note = note
        self.groupId = groupId
    }
}
