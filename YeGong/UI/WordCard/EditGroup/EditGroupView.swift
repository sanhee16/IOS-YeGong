//
//  EditGroupView.swift
//  YeGong
//
//  Created by sandy on 2023/06/14.
//

import SwiftUI

struct EditGroupView: View {
    typealias VM = EditGroupViewModel
    public static func vc(_ coordinator: AppCoordinator, type: EditGroupType, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, type: type)
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
                Topbar(vm.type.title, type: .back) {
                    vm.onClose()
                }
                VStack(alignment: .leading, spacing: 0) {
                    groupItem()
                        .padding(.bottom, 12)
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach($vm.voca.wrappedValue.indices, id: \.self) { idx in
                            vocaItem(geometry, idx: idx)
                        }
                        Text("+")
                            .font(.kr20b)
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width - 20, height: 50, alignment: .center)
                            .contentShape(Rectangle())
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.mint)
                            )
                            .onTapGesture {
                                vm.addNewVoca()
                            }
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0))
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 30, trailing: 10))
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func groupItem() -> some View {
        return VStack(alignment: .center, spacing: 8) {
            TextField("Group 이름", text: $vm.group.text)
                .font(.kr12b)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 1.0)
                )
            HStack(alignment: .center, spacing: 0) {
                Text("voca: \($vm.voca.wrappedValue.count)")
                    .font(.kr10r)
                    .foregroundColor(.gray90)
                    .padding(.leading, 10)
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2.0)
        )
    }
    
    private func vocaItem(_ geometry: GeometryProxy, idx: Int) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("영어")
                .font(.kr12b)
                .foregroundColor(.gray90)
            TextField("영어", text: $vm.voca[idx].word)
                .font(.kr12r)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 1.0)
                )
            Text("뜻")
                .font(.kr12b)
                .foregroundColor(.gray90)
                .padding(.top, 4)
            TextField("뜻", text: $vm.voca[idx].mean)
                .font(.kr12r)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 1.0)
                )
            Divider()
                .padding([.top, .bottom], 4)
            Text("예문")
                .font(.kr12b)
                .foregroundColor(.gray90)
            ForEach($vm.voca[idx].examples.indices, id: \.self) { i in
                HStack(alignment: .center, spacing: 8) {
                    MultilineTextField("", text: $vm.voca[idx].examples[i], font: .kr12r, color: .gray90) {
                        
                    }
                    .frame(minHeight: 10.0, alignment: .topLeading)
                    .contentShape(Rectangle())
                    .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.1), radius: 1.0)
                    )
                    Text("-")
                        .font(.kr14b)
                        .foregroundColor(.red)
                        .padding(6)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            $vm.voca[idx].wrappedValue.examples.remove(at: i)
                        }
                }
            }
            Text("+")
                .font(.kr16b)
                .foregroundColor(.white)
                .frame(width: geometry.size.width - 20 - 28, height: 30, alignment: .center)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.mint)
                )
                .onTapGesture {
                    $vm.voca[idx].wrappedValue.examples.append("")
                }
                .padding(.top, 2)
        }
        .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor($vm.voca[idx].wrappedValue.status.color)
                .shadow(color: .black.opacity(0.2), radius: 2.0)
        )
    }
}
