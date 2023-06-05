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
                self.createVocaDB()
                self.firstLaunchTask()
                self.startRepeatTimer()
                Defaults.launchBefore = true
            } else {
                if self.realm.objects(Voca.self).isEmpty {
                    self.createVocaDB()
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
                    if $0.count == 3 {
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
        print("createVocaDB")
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
