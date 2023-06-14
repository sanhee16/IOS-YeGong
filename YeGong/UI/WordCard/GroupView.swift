//
//  WordCardView.swift
//  YeGong
//
//  Created by sandy on 2023/06/09.
//

import SwiftUI
import SwiftUIPager

struct GroupView: View {
    typealias VM = GroupViewModel
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .center) {
                    Topbar("Group")
                    HStack(alignment: .center, spacing: 12) {
                        Spacer()
                        Text("표시")
                            .font(.kr12b)
                            .foregroundColor(.gray90)
                            .onTapGesture {
                                vm.onClickSelectGroup()
                            }
                        Text("추가")
                            .font(.kr12b)
                            .foregroundColor(.gray90)
                            .onTapGesture {
                                
                            }
                    }
                }
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: [
                        GridItem(alignment: .center),
                        GridItem(alignment: .center)
                    ]) {
                        ForEach($vm.groupItems.wrappedValue.indices, id: \.self) { idx in
                            cardItem(geometry, groupItem: $vm.groupItems.wrappedValue[idx])
                        }
                    }
                    .padding([.leading, .trailing], 16)
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
    
    private func cardItem(_ geometry: GeometryProxy, groupItem: WordCardGroupItem) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            Text(groupItem.group.text)
                .font(.kr14b)
                .foregroundColor(.gray90)
            
            Text("voca: \(groupItem.cnt)")
                .font(.kr10b)
                .foregroundColor(.gray60)
                .padding(.top, 6)
            
            HStack(alignment: .center, spacing: 0) {
                Text("퀴즈")
                    .font(.kr12b)
                    .foregroundColor(.gray90)
                    .frame(width: (geometry.size.width - 16 * 2 - 20)/4, height: 40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray30)
                    )
                    .onTapGesture {
                        vm.onClickQuiz(groupItem)
                    }
                Text("학습")
                    .font(.kr12b)
                    .foregroundColor(.gray90)
                    .frame(width: (geometry.size.width - 16 * 2 - 20)/4, height: 40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray30)
                    )
                    .onTapGesture {
                        vm.onClickStudy(groupItem)
                    }
            }
            .padding(.top, 20)
        }
        .padding([.top, .bottom], 20)
        .frame(width: (geometry.size.width - 16 * 2 - 20)/2, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.mint)
        )
    }
}
