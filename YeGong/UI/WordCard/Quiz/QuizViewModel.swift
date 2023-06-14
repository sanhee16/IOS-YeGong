//
//  QuizViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/10.
//

import Foundation
import Combine
import UIKit
import SwiftUIPager
import RealmSwift

class QuizViewModel: BaseViewModel {
    let group: VocaGroup
    private let realm: Realm
    @Published var page: Page
    @Published var list: [Voca]
    @Published var answers: [Voca: [String]]
    private var means: [String]
    
    init(_ coordinator: AppCoordinator, group: VocaGroup) {
        self.group = group
        self.realm = R.realm
        self.page = .withIndex(0)
        self.list = []
        self.answers = [:]
        self.means = []
        super.init(coordinator)
    }
    
    func onAppear() {
        self.getVoca()
        self.createAnswerSheet()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func getVoca() {
        self.list.removeAll()
        self.means.removeAll()
        
        self.list = Array(self.realm.objects(Voca.self).filter({ voca in
            voca.groupId == self.group._id
        })).shuffled()
        self.means = self.list.map({ voca in
            return voca.mean
        })
    }
    
    func createAnswerSheet() {
        self.answers.removeAll()
        self.list.forEach { voca in
            if self.means.count <= 4 {
                self.answers[voca] = self.means
            } else {
                self.answers[voca] = [voca.mean]
                let newList = self.means.filter { str in
                    str != voca.mean
                }.shuffled()
                self.answers[voca]?.append(contentsOf: newList[0...2])
            }
            self.answers[voca]?.shuffle()
        }
    }
    
    func onClickAnswer(_ voca: Voca, answer: String) {
        if voca.mean == answer {
            print("맞음!")
        } else {
            print("틀림!")
        }
    }
}
