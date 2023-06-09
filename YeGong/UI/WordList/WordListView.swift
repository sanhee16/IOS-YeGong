//
//  WordListView.swift
//  YeGong
//
//  Created by sandy on 2023/06/06.
//

import SwiftUI

struct WordListView: View {
    typealias VM = WordListViewModel
    //    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
    ////        let vm = VM.init(coordinator)
    //        let view = Self.init(vm: vm)
    //        let vc = BaseViewController.init(view, completion: completion)
    //        return vc
    //    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    private let allTypes: [LevelBadgeType] = [.lv1, .lv2, .lv3]
    @State private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                VStack(alignment: .leading, spacing: 0) {
                    Topbar("WordList")
                    /*
                     필터링 기능: 레벨
                     단어 가리기 or 한글 가리기
                     */
                    
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        //TODO: 레벨 부분은 설정으로 빼야할 것 같음 ㅠ
//                        Text("레벨:")
//                            .font(.kr12r)
//                            .foregroundColor(.gray90)
//                            .padding(.trailing, 3)
//                        ForEach(self.allTypes.indices, id: \.self) { idx in
//                            filterItem(self.allTypes[idx])
//                                .padding(.leading, 2)
//                                .onTapGesture {
//                                    vm.onClickFilter(self.allTypes[idx])
//                                }
//                        }
//
//                        Divider()
//                            .frame(height: 20, alignment: .center)
//                            .padding(6)
                        
                        Text("표출:")
                            .font(.kr12r)
                            .foregroundColor(.gray90)
                            .padding(.trailing, 3)
                        visibleItem("영어", isVisible: $vm.isVisibleWord.wrappedValue)
                            .onTapGesture {
                                $vm.isVisibleWord.wrappedValue = !$vm.isVisibleWord.wrappedValue
                                Defaults.isVisibleWord = $vm.isVisibleWord.wrappedValue
                            }
                            .padding(.trailing, 2)
                        visibleItem("한글", isVisible: $vm.isVisibleMean.wrappedValue)
                            .onTapGesture {
                                $vm.isVisibleMean.wrappedValue = !$vm.isVisibleMean.wrappedValue
                                Defaults.isVisibleMean = $vm.isVisibleMean.wrappedValue
                            }
                    }
                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 8))
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 0) {
                            ForEach($vm.list.wrappedValue.indices, id: \.self) { idx in
                                switch $vm.list.wrappedValue[idx].type.getVocaType() {
                                case VocaType.group:
                                    groupItem($vm.list.wrappedValue[idx].word)
                                        .id(idx)
                                case VocaType.word:
                                    wordItem($vm.list.wrappedValue[idx], idx: idx)
                                        .id(idx)
                                default:
                                    EmptyView()
                                }
                                Divider()
                                    .padding(0)
                            }
                            .onAppear {
                                scrollProxy.scrollTo(0, anchor: .top)
                            }
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
                .edgesIgnoringSafeArea(.all)
                .frame(width: geometry.size.width, alignment: .leading)
                .onAppear {
                    vm.onAppear()
                }
            }
        }
    }
    
    private func groupItem(_ text: String) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Text(text)
                .font(.kr13b)
                .foregroundColor(.gray90)
                .padding([.leading, .top, .bottom], 10)
            Spacer()
        }
        .background(.mint)
    }
    
    private func visibleItem(_ text: String, isVisible: Bool) -> some View {
        return ZStack(alignment: .center) {
            Text(text)
                .font(.kr14r)
                .foregroundColor(.black)
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 34, height: 22, alignment: .center)
                .foregroundColor(isVisible ? Color(hex: "#069168") : .gray30)
        }
        .contentShape(Rectangle())
    }
    
    private func filterItem(_ item: LevelBadgeType) -> some View {
        return ZStack(alignment: .center) {
            Text(item.text)
                .font(.kr14r)
                .foregroundColor(.black)
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: 2)
                .frame(both: 22, aligment: .center)
                .foregroundColor($vm.filters.wrappedValue.contains(where: { $0 == item }) ? item.color : .gray30)
        }
    }
    
    private func wordItem(_ item: Voca, idx: Int) -> some View {
        return ZStack(alignment: .topLeading) {
//            if idx == $vm.bookmarkIdx.wrappedValue {
//                Image("bookmark")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 30, alignment: .center)
//                    .opacity(0.5)
//                    .zIndex(1)
//            }
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 4) {
                        Text($vm.isVisibleWord.wrappedValue ? item.word : "")
                            .font(.kr18b)
                            .foregroundColor(.gray90)
                        WordLevelBadge(type: item.level.levelBadgeType())
                    }
                    Text($vm.isVisibleMean.wrappedValue ? item.mean : "")
                        .font(.kr16r)
                        .foregroundColor(.gray60)
                }
                Spacer()
                Image(item.starTime == nil ? "star_off" : "star_on")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 20)
                    .onTapGesture {
                        vm.onTapStar(item)
                    }
            }
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        }
        .contentShape(Rectangle())
    }
}
