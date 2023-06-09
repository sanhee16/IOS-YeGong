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

enum VocaType: Int {
    case group = 1
    case word = 2
}
/*
 Type
 1: Group
 2: Word
 
*/

class Voca: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var type: Int
    @Persisted var word: String
    @Persisted var mean: String
    @Persisted var level: Int
    @Persisted var examples: List<String>
    @Persisted var starTime: Int? //epoch
    @Persisted var studyTime: Int? //epoch
    @Persisted var wrongCnt: Int
    @Persisted var group: String
    
    convenience init(_ item: VocaCSVModel) {
        self.init()
        let list = List<String>()
        item.examples.forEach {i in
            list.append(i)
        }
        self.type = 0
        self.word = item.word
        self.mean = item.mean
        self.level = item.level
        self.examples = list
        
        self.starTime = nil
        self.studyTime = nil
        self.wrongCnt = 0
        self.group = ""
    }
    
    convenience init(id: ObjectId, type: Int, word: String, mean: String, level: Int, examples: List<String>, starTime: Int?, studyTime: Int?, wrongCnt: Int, group: String
    ) {
        self.init()
        self._id = id
        self.type = type
        self.word = word
        self.mean = mean
        self.level = level
        self.examples = examples
        self.starTime = starTime
        self.studyTime = studyTime
        self.wrongCnt = wrongCnt
        self.group = group
    }
}
