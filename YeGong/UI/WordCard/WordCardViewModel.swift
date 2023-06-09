//
//  WordCardViewModel.swift
//  YeGong
//
//  Created by sandy on 2023/06/09.
//

import Foundation
import Combine
import UIKit

class WordCardViewModel: BaseViewModel {
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
}
