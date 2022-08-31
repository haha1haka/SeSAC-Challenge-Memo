//
//  MainTableViewCell.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class MainTableViewCell: BaseTableViewCell {
    
    
    
    let label: UILabel = {
        let view = UILabel()
//        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    override func configure() {
        contentView.addSubview(label)
    }







    override func setConstraints() {
        label.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(10)
        }
    }
    
    
    
    
    
}
