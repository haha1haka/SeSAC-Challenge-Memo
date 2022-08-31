//
//  mainView.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class MainView: BaseView {
    

    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .black
        view.rowHeight = 44
        return view
    }()

    
   

    
    
    override func configure() {

        [tableView].forEach { self.addSubview($0) }
    }
    
    
    override func setConstraints() {

        
        
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(0)
            $0.height.equalToSuperview()
        }

    }
}





enum SearchBarScope: Int {
    case first
    case second
    case third
    
    var result: String {
        switch self {
        case .first:
            return "일기"
        case .second:
            return "과제"
        case .third:
            return "애플"
        }
    }
}
