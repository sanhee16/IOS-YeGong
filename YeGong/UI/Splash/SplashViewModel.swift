//
//  SplashViewModel.swift
//  YeGong
//
//  Created by sandy on 2022/10/05.
//


import Foundation
import Combine
import AVFoundation
import UserNotifications
import UIKit
import AppTrackingTransparency
import RealmSwift


class SplashViewModel: BaseViewModel {
    private var timerRepeat: Timer?
    private let realm: Realm
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
    }
    
    func onAppear() {
        checkNetworkConnect() {[weak self] in
            guard let self = self else { return }
            if !Defaults.launchBefore {
                self.firstLaunchTask()
                self.onStartSplashTimer()
                Defaults.launchBefore = true
            } else {
                if self.realm.objects(Voca.self).isEmpty {
                    self.createVocaDB()
                } else {
                    let list = self.realm.objects(Voca.self)
                    print("------VOCA------")
                    print("cnt: \(list.count)")
                    print("\(list[0])")
                    print("\(list[1])")
                    print("\(list[2])")
                    print("\(list[3])")
                    print("\(list[4])")
                    print("\(list[5])")
                    
                    print("\(list[200])")
                    print("\(list[201])")
                    print("\(list[202])")
                    print("\(list[203])")
                    print("\(list[204])")
                    print("\(list[205])")
                    
                    print("\(list[400])")
                    print("\(list[401])")
                    print("\(list[402])")
                    print("\(list[403])")
                    print("\(list[404])")
                    print("\(list[405])")
                    
                    print("\(list[700])")
                    print("\(list[701])")
                    print("\(list[702])")
                    print("\(list[703])")
                    print("\(list[704])")
                    print("\(list[705])")
                    
                    print("\(list[900])")
                    print("\(list[901])")
                    print("\(list[902])")
                    print("\(list[903])")
                    print("\(list[904])")
                    print("\(list[905])")
                }
                self.onStartSplashTimer()
            }
        }
    }
    
    private func parseCSVAt(url: URL) -> [VocaCSVModel] {
        var list: [VocaCSVModel] = []
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                list = dataArr.compactMap({
                    if $0.count == 4 {
                        return VocaCSVModel($0)
                    } else {
                        return nil
                    }
                })
            }
            return list
        } catch {
            print("Error reading CSV file")
            return []
        }
    }
    
    private func loadVoca() -> String? {
        return Bundle.main.path(forResource: "Voca", ofType: "csv")
    }
    
    private func insertToDB(_ list: [VocaCSVModel]) {
        let vocaList = list.map { cvsModel -> Voca in
            return Voca(cvsModel)
        }
        if !vocaList.isEmpty {
            try! realm.write {
                realm.add(vocaList)
            }
        }
    }
    
    private func createVocaDB() {
        if let path = loadVoca() {
            let list = parseCSVAt(url: URL(fileURLWithPath: path))
            insertToDB(list)
        }
    }
    
    // 반복 타이머 실행
    @objc func timerFireRepeat(timer: Timer) {
        if timer.userInfo != nil {
            // 작업 해야할 것
            self.checkTrackingPermission { [weak self] in
                // 작업이 끝나면 stopRepeatTimer 호출
                self?.stopRepeatTimer()
            }
        }
    }
    
    private func firstLaunchTask() {
        self.createVocaDB()
    }
    
    
    private func checkTrackingPermission(_ nextTask: @escaping ()->()) {
        ATTrackingManager.requestTrackingAuthorization { status in
            nextTask()
        }
    }
    
    func onStartSplashTimer() { //2초 후에 메인 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.coordinator?.presentMain()
        }
    }
    
    // 반복 타이머 시작
    func startRepeatTimer() {
        timerRepeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFireRepeat(timer:)), userInfo: "check permission", repeats: true)
    }
    
    
    // 반복 타이머 종료
    func stopRepeatTimer() {
        if let timer = timerRepeat {
            if timer.isValid {
                timer.invalidate()
            }
            timerRepeat = nil
            // timer 종료되고 작업 시작
            onStartSplashTimer()
        }
    }
    
}
