//
//  AppCoordinator.swift
//  YeGong
//
//  Created by sandy on 2023/06/03.
//

import SwiftUI

class AppCoordinator: Coordinator, Terminatable {
    // UIWindow = 화면에 나타나는 View를 묶고, UI의 배경을 제공하고, 이벤트 처리행동을 제공하는 객체 = View들을 담는 컨테이너
    let window: UIWindow
    
    /*
     SceneDelegate에서 window rootViewController 설정해줘야 하는데 window 여기로 가지고와서 여기서 설정해줌
     */
    init(window: UIWindow) { // SceneDelegate에서 호출
        self.window = window
        super.init() // Coordinator init
        let navigationController = UINavigationController()
        self.navigationController = navigationController // Coordinator의 navigationController
        
        // rootViewController 지정 + makeKeyAndVisible 호출 = 지정한 rootViewController가 상호작용을 받는 현재 화면으로 세팅 완료
        self.window.rootViewController = navigationController // window의 rootViewController
        window.makeKeyAndVisible()
    }
    
    // Terminatable
    func appTerminate() {
        print("app Terminate")
        for vc in self.childViewControllers {
            print("terminate : \(type(of: vc))")
            (vc as? Terminatable)?.appTerminate()
        }
        if let navigation = self.navigationController as? UINavigationController {
            for vc in navigation.viewControllers {
                (vc as? Terminatable)?.appTerminate()
            }
        } else {
            
        }
        print("terminate : \(type(of: self.navigationController))")
        (self.navigationController as? Terminatable)?.appTerminate()
    }
    
    //MARK: Start
    func startSplash() {
        let vc = SplashView.vc(self)
        self.present(vc, animated: true)
    }
    
    //MARK: Present
    func presentMain() {
        let vc = MainView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentAlertView(_ type: AlertType, title: String?, description: String?, callback: ((Bool) -> ())?) {
        let vc = AlertView.vc(self, type: type, title: title, description: description, callback: callback)
        self.present(vc, animated: false)
    }
}
