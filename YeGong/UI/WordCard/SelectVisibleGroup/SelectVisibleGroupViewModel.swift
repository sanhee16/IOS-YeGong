//
//  SelectVisibleGroupViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/14.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class SelectVisibleGroupViewModel: BaseViewModel {
    @Published var groups: [VocaGroup] = []
    private let realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = R.realm
        super.init(coordinator)
    }
    
    func onAppear() {
        self.getGroups()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func getGroups() {
        self.groups.removeAll()
        self.groups = Array(self.realm.objects(VocaGroup.self))
    }
    
    func onClickGroup(_ group: VocaGroup) {
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            if let item = self.realm.object(ofType: VocaGroup.self, forPrimaryKey: group._id) {
                item.isVisible = !item.isVisible
                self.realm.add(item, update: .modified)
                self.getGroups()
            }
        }
    }
    
    func onClickSelectAll() {
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            Array(self.realm.objects(VocaGroup.self))
                .forEach { group in
                    group.isVisible = true
                    self.realm.add(group, update: .modified)
                }
            self.getGroups()
        }
    }
    
    func onClickUnSelectAll() {
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            Array(self.realm.objects(VocaGroup.self))
                .forEach { group in
                    group.isVisible = false
                    self.realm.add(group, update: .modified)
                }
            self.getGroups()
        }
    }
}
