//
//  SplashViewModel.swift
//  Footprint
//
//  Created by sandy on 2022/10/05.
//


import Foundation
import Combine
import AVFoundation
import UserNotifications
import UIKit
import AppTrackingTransparency

class SplashViewModel: BaseViewModel {
    private var timerRepeat: Timer?
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        checkNetworkConnect() {[weak self] in
            guard let self = self else { return }
            if !Defaults.launchBefore {
                Defaults.launchBefore = true
                self.firstLaunchTask()
                self.startRepeatTimer()
            } else {
                self.onStartSplashTimer()
            }
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
