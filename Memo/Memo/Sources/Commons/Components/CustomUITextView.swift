//
//  MyTextfield.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit

class CustomUITextView: UITextView {
    

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUI() {
        backgroundColor = COLOR_BRANDI_PRIMARY
        textColor = .label
        tintColor = Color.memoYellow
        font = .systemFont(ofSize: 22, weight: .regular)
    }
}
