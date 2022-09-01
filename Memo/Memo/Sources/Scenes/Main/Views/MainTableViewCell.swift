//
//  MainTableViewCell.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class MainTableViewCell: BaseTableViewCell {
    
    
    
    let mainLabel: UILabel = {
        let view = UILabel()
        
        view.backgroundColor = .red
        return view
    }()
    
    let dateLabel: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.backgroundColor = .orange
        return view
    }()
    
    
    
    override func configure() {
        
        [mainLabel, dateLabel].forEach { contentView.addSubview($0)}
    }







    override func setConstraints() {
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(self.snp.height).dividedBy(1.5)
        }
        
        
        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
//            $0.height.equalTo(11)
        }
    }
    
    
    
    
    
}
