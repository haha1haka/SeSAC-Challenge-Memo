//
//  detailView.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class DetailView: BaseView {
        
    var textView = CustomUITextView()
    
    override func configureHierarchy() {
        self.addSubview(textView)
    }

    override func configureLayout() {
        textView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(self).offset(-10)
        }
    }
}
