//
//  BaseView.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//
import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = COLOR_BRANDI_PRIMARY
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    
}

