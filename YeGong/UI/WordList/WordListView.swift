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
    @State private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("WordList")
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 0) {
                            ForEach($vm.list.wrappedValue.indices, id: \.self) { idx in
                                wordItem($vm.list.wrappedValue[idx], idx: idx)
                                    .id(idx)
                                Divider()
                                    .padding(0)
                            }
                            .onAppear {
                                scrollProxy.scrollTo($vm.lastStudyIdx.wrappedValue, anchor: .top)
                            }
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
    
    private func wordItem(_ item: Voca, idx: Int) -> some View {
        return ZStack(alignment: .topLeading) {
            if idx == $vm.lastStudyIdx.wrappedValue {
                Image("bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 30, alignment: .center)
                    .opacity(0.5)
                    .zIndex(1)
            }
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(item.word)
                            .font(.kr18b)
                            .foregroundColor(.gray90)
                        WordLevelBadge(type: item.level.levelBadgeType())
                    }
                    Text(item.mean)
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
        .onTapGesture(count: 2, perform: {
            vm.onLongClick(idx)
        })
    }
}
