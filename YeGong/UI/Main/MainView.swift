//
//  MainView.swift
//  YeGong
//
//  Created by sandy on 2022/10/05.
//

import SwiftUI
import Foundation


//TODO: MainTabBar, Views, 광고 Banner 등 설정하기
/*
 1. 전체 단어 리스트 -> 필터링 기능: 레벨 / 보기 기능: 수직 스크롤 / 단어 가리기 or 한글 가리기
    검색 기능 추가 -> 바로바로 스크롤 되게
    단어 클릭시 2번 탭으로 넘어가게 -> 뒤로가기하면 다시 1번탭으로..?
 2. 공부하기 -> 수평 카드 형식 / 단어 가리기 or 한글 가리기 -> 탭에서 제외시키자
 3. 북마크
 
 
 
 1. 전체
 필터링 기능: 레벨
 단어 가리기 or 한글 가리기
    - 리스트로 보기: 수직 스크롤
    - 클릭시 카드형식으로 보기: 수평 카드
 2. 북마크
     - 리스트로 보기: 수직 스크롤
     - 클릭시 카드형식으로 보기: 수평 카드
 3. 시험 -> 영어 / 한글 / 선택하기 / 힌트는 예문으로! + 오답을 여기에 포함해야지
 4. 설정 - 예문 on/off
 */
struct MainView: View {
    typealias VM = MainViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let wordlistVm = WordListViewModel.init(coordinator)
        let wordcardVm = WordCardViewModel.init(coordinator)
//        let listVm = FootprintListViewModel.init(coordinator)
//        let travelVm = TravelListViewModel.init(coordinator)
//        let settingVm = SettingViewModel.init(coordinator)
        
        let view = Self.init(vm: vm, wordlistVm: wordlistVm, wordcardVm: wordcardVm)
//        let view = Self.init(vm: vm, mapVm: mapVm, listVm: listVm, travelVm: travelVm, settingVm: settingVm)
        let vc = BaseViewController.init(view, completion: completion) {
            vm.viewDidLoad()
        }
        return vc
    }
    
    @ObservedObject var vm: VM
    @ObservedObject var wordlistVm: WordListViewModel
    @ObservedObject var wordcardVm: WordCardViewModel
//    @ObservedObject var travelVm: TravelListViewModel
//    @ObservedObject var settingVm: SettingViewModel
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let optionHeight: CGFloat = 36.0
    private let optionVerticalPadding: CGFloat = 8.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                switch($vm.currentTab.wrappedValue) {
                case .wordlist:
                    WordListView(vm: self.wordlistVm)
                case .wordcard:
                    WordCardView(vm: self.wordcardVm)
//                case .travel:
//                    TravelListView(vm: self.travelVm)
//                case .setting:
//                    SettingView(vm: self.settingVm)
//                default:
//                    SettingView(vm: self.settingVm)
                }
//                if Defaults.premiumCode.isEmpty && $vm.isShowAds.wrappedValue {
//                    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
//                }

                MainTabBar(geometry: geometry, current: $vm.currentTab.wrappedValue) { type in
                    vm.onClickTab(type)
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
}
