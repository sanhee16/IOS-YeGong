//
//  QuizView.swift
//  YeGong
//
//  Created by sandy on 2023/06/10.
//

import SwiftUI
import SwiftUIPager

struct QuizView: View {
    typealias VM = QuizViewModel
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
                        Spacer()
                        Text(voca.word)
                            .font(.kr45b)
                            .foregroundColor(.gray90)
                            .padding([.leading, .trailing], 10)
                        
                        VStack(alignment: .center, spacing: 0) {
                            if let answerList = $vm.answers.wrappedValue[voca] {
                                ForEach(answerList.indices, id: \.self) { idx in
                                    answerItem(geometry, voca: voca, answer: answerList[idx])
                                }
                                .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
                            }
                        }
                        .padding(.top, 24)
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
    
    private func answerItem(_ geometry: GeometryProxy, voca: Voca, answer: String) -> some View {
        return Text(answer)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
            .font(.kr20r)
            .foregroundColor(.gray90)
            .padding([.top, .bottom], 16)
            .frame(width: (geometry.size.width - 24 - 20), alignment: .center)
            .background (
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.gray30)
            )
            .onTapGesture {
                vm.onClickAnswer(voca, answer: answer)
            }
    }
}
