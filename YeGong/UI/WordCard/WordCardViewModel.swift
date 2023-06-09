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

class WordCardViewModel: BaseViewModel {
    private let realm: Realm
    @Published var list: [Voca]
    @Published var filters: [LevelBadgeType] = []
    @Published var isVisibleWord: Bool = Defaults.isVisibleWord
    @Published var isVisibleMean: Bool = Defaults.isVisibleMean
    
    override init(_ coordinator: AppCoordinator) {
        self.list = []
        self.realm = R.realm
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}
