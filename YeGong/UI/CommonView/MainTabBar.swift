//
//  MainTabBar.swift
//  YeGong
//
//  Created by sandy on 2023/06/04.
//

import Foundation
import SwiftUI

public struct MainMenuElements {
    var current: MainMenuType
    var onClick: ((MainMenuType)->())?
}

public enum MainMenuType: Int, Equatable {
    case wordlist
    case group
//    case bookmark
//    case setting
    
    var onImage: String {
        switch self {
        case .wordlist: return "list_on"
        case .group: return "list_on"
//        case .bookmark: return "favorite_off"
//        case .setting: return "setting_on"
        }
    }
    
    var offImage: String {
        switch self {
        case .wordlist: return "list_off"
        case .group: return "list_off"
//        case .bookmark: return "favorite_off"
//        case .setting: return "setting_off"
        }
    }
    
    var text: String {
        switch self {
        case .wordlist: return "wordlist".localized()
        case .group: return "group".localized()
//        case .bookmark: return "bookmark".localized()
//        case .setting: return "setting".localized()
        }
    }
    
    var viewName: String {
        switch self {
        case .wordlist: return String(describing: WordListView.self)
        case .group: return String(describing: GroupView.self)
//        case .bookmark: return String(describing: WordListView.self)
//        case .setting: return String(describing: TravelListView.self)
        }
    }
}

public struct MainTabBar: View {
    private var current: MainMenuType
    private var onClick: ((MainMenuType)->())?
    private let geometry: GeometryProxy
    private let ICON_SIZE: CGFloat = 38.0
    private let ITEM_WIDTH: CGFloat = UIScreen.main.bounds.width / 4
    private let ITEM_HEIGHT: CGFloat = 60.0
    private let list: [MainMenuType] = [.wordlist, .group]
    
    init(geometry: GeometryProxy, current: MainMenuType, onClick: ((MainMenuType)->())?) {
        self.geometry = geometry
        self.current = current
        self.onClick = onClick
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(self.list.indices, id: \.self) { idx in
                drawItem(self.list[idx], isSelected: self.list[idx] == self.current)
            }
        }
        .background(Color.backgroundColor)
    }
    
    private func drawItem(_ item: MainMenuType, isSelected: Bool) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            Image(isSelected ? item.onImage : item.offImage)
                .resizable()
                .scaledToFit()
                .frame(both: ICON_SIZE, aligment: .center)
            Text(item.text)
                .font(isSelected ? .kr10b : .kr10r)
                .foregroundColor(isSelected ? .fColor3 : .textColor1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            switch item {
            case .wordlist: self.onClick?(.wordlist)
            case .group: self.onClick?(.group)
            }
        }
        .frame(width: ITEM_WIDTH, height: ITEM_HEIGHT, alignment: .center)
    }
}




