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
    @objc dynamic var pronounce: String
    dynamic var examples: List<String>
    
    override required init() {
        self.word = ""
        self.pronounce = ""
        self.examples = List<String>()
    }
    
    init(_ item: VocaCSVModel) {
        let list = List<String>()
        item.examples.forEach {i in
            list.append(i)
        }
        self.word = item.word
        self.pronounce = item.pronounce
        self.examples = list
        super.init()
    }
}
