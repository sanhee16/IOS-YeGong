//
//  EditGroupViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/14.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import RealmSwift


enum EditGroupType {
    case create
    case modify(group: VocaGroup)
    
    var title: String {
        switch self {
        case .create: return "그룹 생성하기"
        case .modify(group: _): return "그룹 수정하기"
        }
    }
}

enum EditStatus {
    case done
    case unVoca
    case unGroup
}

enum EditVocaStauts {
    case new
    case savable
    case notSavable
    
    var uiColor: UIColor {
        switch self {
        case .new: return UIColor(hex: "#C6C6C6")
        case .savable: return UIColor(hex: "#80D1FF")
        case .notSavable: return UIColor(hex: "#FF8080")
        }
    }
    
    var color: Color {
        switch self {
        case .new: return Color(hex: "#C6C6C6")
        case .savable: return Color(hex: "#80D1FF")
        case .notSavable: return Color(hex: "#FF8080")
        }
    }
}

struct EditVoca {
    var id: ObjectId?
    var word: String
    var mean: String
    var level: Int?
    var examples: [String]
    var status: EditVocaStauts {
        if self.word.isEmpty && self.mean.isEmpty {
            return .new
        } else if !self.word.isEmpty && !self.mean.isEmpty {
            return .savable
        } else {
            return .notSavable
        }
    }
    
    init(id: ObjectId? = nil, word: String = "", mean: String = "", level: Int? = nil, examples: [String] = []) {
        self.id = id
        self.word = word
        self.mean = mean
        self.level = level
        self.examples = examples
    }
}

class EditGroupViewModel: BaseViewModel {
    @Published var group: VocaGroup
    @Published var voca: [EditVoca]
    var type: EditGroupType
    
    private let realm: Realm
    private var status: EditStatus {
        if self.group.text.isEmpty {
            return .unGroup
        } else if voca.filter({ voca in
            voca.status == .notSavable
        }).count > 0  {
            return .unVoca
        }
        return .done
    }
    
    init(_ coordinator: AppCoordinator, type: EditGroupType) {
        self.type = type
        self.realm = R.realm
        switch self.type {
        case let .modify(group: gr):
            self.group = gr
            break
        case .create:
            self.group = VocaGroup("", isEditable: true)
            break
        }
        self.voca = []
        super.init(coordinator)
        self.objectWillChange.send()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        switch self.status {
        case .unGroup:
            self.alert(.yesOrNo, title: "저장하지 않고 종료하시겠습니까", description: "그룹 정보가 완성되지 않아 저장되지 않습니다.") {[weak self] res in
                guard let self = self else { return }
                if res { self.dismiss() } else { return }
            }
            break
        case .unVoca:
            self.alert(.yesOrNo, title: "저장하지 않고 종료하시겠습니까?", description: "완성되지 않은 단어가 있어 저장되지 않습니다.") {[weak self] res in
                guard let self = self else { return }
                if res { self.dismiss() } else { return }
            }
            break
        case .done:
            self.onSave {[weak self] in
                self?.dismiss()
            }
            break
        }
    }
    
    private func loadVoca() {
        switch self.type {
        case .modify(group: _):
            self.voca = Array(self.realm.objects(Voca.self).filter({ voca in
                voca.groupId == self.group._id
            })).map({ voca in
                EditVoca(id: voca._id, word: voca.word, mean: voca.mean, level: voca.level)
            })
            break
        case .create:
            break
        }
        self.addNewVoca()
    }
    
    private func onSave(_ onDone: @escaping ()->()) {
        if let existGroup = self.realm.object(ofType: VocaGroup.self, forPrimaryKey: self.group._id) {
            try! self.realm.write {[weak self] in
                guard let self = self else { return }
                let saveGroup = existGroup
                saveGroup.text = self.group.text
                self.realm.add(saveGroup, update: .modified)
            }
        } else {
            if self.group.text.isEmpty {
                return
            }
            try! self.realm.write {[weak self] in
                guard let self = self else { return }
                self.realm.add(self.group)
            }
        }
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            self.voca.forEach { voca in
                if voca.status == .new { return }
                let list = RealmSwift.List<String>()
                voca.examples.filter({ str in
                    !str.isEmpty
                }).forEach {i in
                    list.append(i)
                }
                let item = Voca(voca.word, mean: voca.mean, level: nil, examples: list, note: "", groupId: self.group._id)
                self.realm.add(item)
            }
        }
        onDone()
    }
    
    func addNewVoca() {
        self.voca.append(EditVoca())
    }
}
