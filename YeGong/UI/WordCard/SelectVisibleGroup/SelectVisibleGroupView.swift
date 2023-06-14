//
//  SelectVisibleGroupView.swift
//  YeGong
//
//  Created by sandy on 2023/06/14.
//

import SwiftUI

struct SelectVisibleGroupView: View {
    typealias VM = SelectVisibleGroupViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.bottomSheet(view, sizes: [.fullscreen])
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let horizontalPadding: CGFloat = 12.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("그룹 선택하기", type: .back) {
                    vm.onClose()
                }
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(),GridItem()], alignment: .center, spacing: 8, pinnedViews: []) {
                        ForEach($vm.groups.wrappedValue.indices, id: \.self) { idx in
                            groupItem(geometry, group: $vm.groups.wrappedValue[idx])
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10))
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func groupItem(_ geometry: GeometryProxy, group: VocaGroup) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Text(group.text)
                .font(.kr14b)
                .foregroundColor(group.isVisible ? .gray90 : .gray60)
            Spacer()
            SToggleView(width: 36.0, height: 20.0, color: .mint, isOn: Binding(get: {
                group.isVisible
            }, set: { value in
                
            })) {
                vm.onClickGroup(group)
            }
        }
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2.0)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                vm.onClickGroup(group)
            }
        }
    }
}

