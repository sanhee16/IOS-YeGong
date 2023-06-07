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

class Voca: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var word: String
    @Persisted var mean: String
    @Persisted var level: Int
    @Persisted var examples: List<String>
    @Persisted var bookmarkTime: Int? //epoch
    @Persisted var studyTime: Int? //epoch
    @Persisted var wrongCnt: Int
    
    convenience init(_ item: VocaCSVModel) {
        self.init()
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
    }
    
    convenience init(id: ObjectId, word: String, mean: String, level: Int, examples: List<String>, bookmarkTime: Int?, studyTime: Int?, wrongCnt: Int
    ) {
        self.init()
        self._id = id
        self.word = word
        self.mean = mean
        self.level = level
        self.examples = examples
        self.bookmarkTime = bookmarkTime
        self.studyTime = studyTime
        self.wrongCnt = wrongCnt
    }
}
