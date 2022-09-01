//
//  IntroViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit

class IntroViewController: BaseViewController {
    let introView = IntroView()
    
    override func loadView() {
        self.view = introView
    }
    
    override func configure() {
    }
}
