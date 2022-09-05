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
        // 첫화면 루트뷰 약간 어둑하게 해주기
        introView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        introView.button.addTarget(self, action: #selector(startButtonCliked), for: .touchUpInside)
    }
}

// MARK: - Methods
extension IntroViewController {
    @objc func startButtonCliked() {
        self.dismiss(animated: true)
    }
}
