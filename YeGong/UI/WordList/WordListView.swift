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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("WordList")
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach($vm.list.wrappedValue.indices, id: \.self) { idx in
                        wordItem($vm.list.wrappedValue[idx])
                    }
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func wordItem(_ item: Voca) -> some View {
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 6) {
                WordLevelBadge(type: item.level.levelBadgeType())
                Text(item.word)
                    .font(.kr14b)
                    .foregroundColor(.gray90)
                Spacer()
                
                //TODO: 북마크 표시
                Image(item.bookmarkTime == nil ? "star_off" : "star_on")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 14)
                    .onTapGesture {
                        vm.onTapBookmark(item)
                    }
            }
            Text(item.mean)
                .font(.kr12r)
                .foregroundColor(.gray60)
        }
    }
}
