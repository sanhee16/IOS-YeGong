//
//  AdView.swift
//  YeGong
//
//  Created by sandy on 2023/06/04.
//

import Foundation
import SwiftUI


/*
 usage: GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
 */
//struct GADBanner: UIViewControllerRepresentable {
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = GADBannerView(adSize: GADAdSizeBanner)
//        let viewController = UIViewController()
//        view.adUnitID = C.devMode == .develop ? "ca-app-pub-3940256099942544/2934735716" : Bundle.main.gadBannerId
//        view.rootViewController = viewController
//        viewController.view.addSubview(view)
//        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
//        view.load(GADRequest())
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        
//    }
//}
