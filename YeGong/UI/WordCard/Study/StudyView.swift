//
//  CardView.swift
//  YeGong
//
//  Created by sandy on 2023/06/09.
//

import SwiftUI
import SwiftUIPager

struct StudyView: View {
    typealias VM = StudyViewModel
    public static func vc(_ coordinator: AppCoordinator, group: VocaGroup, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, group: group)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar(vm.group.text, type: .back) {
                    vm.onClose()
                }
                Pager(page: $vm.page.wrappedValue, data: $vm.list.wrappedValue.indices, id: \.self) { idx in
                    let voca = $vm.list.wrappedValue[idx]
                    VStack(alignment: .center, spacing: 0) {
                        Text(voca.word)
                            .font(.kr45b)
                            .foregroundColor(.gray90)
                        Text(voca.mean)
                            .font(.kr30b)
                            .foregroundColor(.gray60)
                            .padding(.top, 6)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("[예문]")
                                    .font(.kr20b)
                                    .foregroundColor(.gray60)
                                    .padding(.bottom, 4)
                                ForEach(voca.examples.indices, id: \.self) { i in
                                    let example = voca.examples[i]
                                    Text("◦ \(example)")
                                        .font(.kr20r)
                                        .foregroundColor(.gray90)
                                        .padding(.bottom, 6)
                                }
                            }
                            .frame(width: geometry.size.width - 24 - 24, alignment: .leading)
                            .padding(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                        }
                        .padding(.top, 40)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 40, leading: 12, bottom: 20, trailing: 12))
                    .frame(width: geometry.size.width - 24, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.mint)
                    )
                }
                .itemSpacing(10)
                .interactive(scale: 0.9)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
