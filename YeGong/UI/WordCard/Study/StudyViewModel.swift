//
//  CardViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/09.
//

import Foundation
import Combine
import UIKit
import SwiftUIPager
import RealmSwift

class StudyViewModel: BaseViewModel {
    let group: VocaGroup
    private let realm: Realm
    @Published var page: Page
    @Published var list: [Voca]
    
    
    init(_ coordinator: AppCoordinator, group: VocaGroup) {
        self.group = group
        self.realm = R.realm
        self.page = .withIndex(0)
        self.list = []
        super.init(coordinator)
        
    }
    
    func onAppear() {
        self.getVoca()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func getVoca() {
        self.list.removeAll()
        
        self.list = Array(self.realm.objects(Voca.self).filter({ voca in
            voca.groupId == self.group._id
        }))
    }
}
