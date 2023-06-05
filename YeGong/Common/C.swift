//
//  C.swift
//  YeGong
//
//  Created by sandy on 2023/06/04.
//

import Foundation

enum DevMode {
    case release
    case develop
}

public class C {
    static var isFirstAppStart: Bool = true
    
    static var devMode: DevMode = .release
}

