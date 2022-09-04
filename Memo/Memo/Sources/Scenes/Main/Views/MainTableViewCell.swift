//
//  MainTableViewCell.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class MainTableViewCell: BaseTableViewCell {
    
    
    
    
    
    lazy var mainLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .lightGray
        return view
    }()
    
    lazy var contentLabel: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    
    
    override func configure() {
        
        [mainLabel, dateLabel, contentLabel].forEach { contentView.addSubview($0)}
    }







    override func setConstraints() {
        
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.leading.equalTo(self).offset(10)
            $0.trailing.equalTo(self).offset(-10)
            $0.height.equalTo(self.snp.height).dividedBy(1.7)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(self).offset(10)
            $0.trailing.equalTo(contentLabel.snp.leading).priority(999)
            $0.bottom.equalTo(self)
            $0.top.equalTo(mainLabel.snp.bottom)
        }
        
        
        contentLabel.snp.makeConstraints {
            $0.bottom.equalTo(self)
            $0.leading.equalTo(dateLabel.snp.trailing).inset(10).priority(998)
//            $0.trailing.equalTo(self)
            $0.top.equalTo(mainLabel.snp.bottom)

        }
    }
    
    
    
    
    
}
