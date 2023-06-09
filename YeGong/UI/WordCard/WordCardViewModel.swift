//
//  WordCardViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/09.
//

import Foundation
import Combine
import UIKit
import RealmSwift


struct WordCardGroupItem {
    var group: VocaGroup
    var cnt: Int
}

class WordCardViewModel: BaseViewModel {
    private let realm: Realm
    @Published var list: [Voca]
    @Published var groups: [VocaGroup]
    @Published var groupItems: [WordCardGroupItem]
    @Published var filters: [LevelBadgeType] = []
    @Published var isVisibleWord: Bool = Defaults.isVisibleWord
    @Published var isVisibleMean: Bool = Defaults.isVisibleMean
    
    override init(_ coordinator: AppCoordinator) {
        self.list = []
        self.groups = []
        self.groupItems = []
        self.realm = R.realm
        super.init(coordinator)
    }
    
    func onAppear() {
        self.getVoca()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func getVoca() {
        Defaults.studyFilter.forEach { i in
            if let type = LevelBadgeType(rawValue: i) {
                self.filters.append(type)
            }
        }

        self.list.removeAll()
        self.groups.removeAll()
        self.groupItems.removeAll()
        
        self.list = Array(self.realm.objects(Voca.self).filter({ voca in
            self.filters.contains { $0.rawValue == voca.level }
        }))
        self.groups = Array(self.realm.objects(VocaGroup.self))
        self.groupItems = self.groups.map({ group in
            let cnt = Array(self.list.filter { voca in
                voca.groupId == group._id
            }).count
            return WordCardGroupItem(group: group, cnt: cnt)
        })
        
    }
    
    func onClickGroup(_ group: WordCardGroupItem) {
        self.coordinator?.presentCardView(group.group)
    }
}
