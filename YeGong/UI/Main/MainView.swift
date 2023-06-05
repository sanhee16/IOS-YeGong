//
//  MainView.swift
//  Footprint
//
//  Created by sandy on 2022/10/05.
//

import SwiftUI
import Foundation


//TODO: MainTabBar, Views, 광고 Banner 등 설정하기
/*
 
 
 */
struct MainView: View {
    typealias VM = MainViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
//        let mapVm = MapViewModel.init(coordinator)
//        let listVm = FootprintListViewModel.init(coordinator)
//        let travelVm = TravelListViewModel.init(coordinator)
//        let settingVm = SettingViewModel.init(coordinator)
        
        let view = Self.init(vm: vm)
//        let view = Self.init(vm: vm, mapVm: mapVm, listVm: listVm, travelVm: travelVm, settingVm: settingVm)
        
        let vc = BaseViewController.init(view, completion: completion) {
            vm.viewDidLoad()
        }
        return vc
    }
    
    @ObservedObject var vm: VM
//    @ObservedObject var mapVm: MapViewModel
//    @ObservedObject var listVm: FootprintListViewModel
//    @ObservedObject var travelVm: TravelListViewModel
//    @ObservedObject var settingVm: SettingViewModel
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Text("Hello, World!")
//                switch($vm.currentTab.wrappedValue) {
//                case .map:
//                    MapView(vm: self.mapVm)
//                case .footprints:
//                    FootprintListView(vm: self.listVm)
//                case .travel:
//                    TravelListView(vm: self.travelVm)
//                case .setting:
//                    SettingView(vm: self.settingVm)
//                default:
//                    SettingView(vm: self.settingVm)
//                }
//                if Defaults.premiumCode.isEmpty && $vm.isShowAds.wrappedValue {
//                    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
//                }

//                MainTabBar(geometry: geometry, current: $vm.currentTab.wrappedValue) { type in
//                    vm.onClickTab(type)
//                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
}
