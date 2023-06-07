//
//  WordListViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/06.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class WordListViewModel: BaseViewModel {
    @Published var list: [Voca]
    @Published var bookmarkIdx: Int = Defaults.bookmarkIdx
    @Published var filters: [LevelBadgeType] = []
    @Published var isVisibleWord: Bool = Defaults.isVisibleWord
    @Published var isVisibleMean: Bool = Defaults.isVisibleMean
    private var isLoading: Bool = false
    private let realm: Realm
    
    override init(_ coordinator: AppCoordinator) {
        self.list = []
        self.realm = R.realm
        super.init(coordinator)
        
        Defaults.studyFilter.forEach { i in
            if let type = LevelBadgeType(rawValue: i) {
                self.filters.append(type)
            }
        }
    }
    
    func onAppear() {
        print("onAppear")
        self.getVoca()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func getVoca() {
        self.list.removeAll()
        self.list = Array(self.realm.objects(Voca.self).filter({ voca in
            self.filters.contains { $0.rawValue == voca.level }
        }))
    }
    
    func onLongClick(_ idx: Int) {
        if Defaults.bookmarkIdx == idx {
            Defaults.bookmarkIdx = 0
        } else {
            Defaults.bookmarkIdx = idx
        }
        self.bookmarkIdx = Defaults.bookmarkIdx
    }
    
    func onClickFilter(_ type: LevelBadgeType) {
        if let idx = self.filters.firstIndex(where: { $0 == type }) {
            self.filters.remove(at: idx)
        } else {
            self.filters.append(type)
        }
        Defaults.studyFilter = self.filters.map({ t in
            t.rawValue
        })
        
        getVoca()
    }
    func onTapStar(_ item: Voca) {
        if isLoading {
            return
        }
        self.isLoading = true
        
        if let idx = self.list.firstIndex(where: {$0._id == item._id}) {
            try! self.realm.write {[weak self] in
                let value = item.starTime == nil ? Util.currentTime() : nil
                
                if let theWord = self?.realm.object(ofType: Voca.self, forPrimaryKey: item._id) {
                    theWord.starTime = value
                    //MARK: Trouble Shooting:
                    /*
                     원래는
                     self?.list[idx] = value
                     로 해서 바로 업데이트 하려고 했는데 업데이트가 안됨.
                     Realm을 업데이트하고 그 값을 다시 받아와야만 list가 업데이트됨
                     왜그런지?? 아마 list메모리가 db자체를 참조? 여서 그럴거같은데.. 모르게씀
                     
                     이거 해결하려고 getVoca에서 값을 복사해서 넣어봤는데 아무 ㅈ쓰잘떼기 없는듯??
                     그냥 일단 'self?.list[idx] = theWord' 코드를 통해야만 list가 업데이트 되었음
                     
                     */
                    self?.list[idx] = theWord
                }
                self?.isLoading = false
            }
        }
    }
}
