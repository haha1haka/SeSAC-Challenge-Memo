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
        view.backgroundColor = COLOR_BRANDI_PRIMARY
        view.rowHeight = 54
        return view
    }()

    
    override func configureHierarchy() {
        
        [tableView].forEach { self.addSubview($0) }
    }
    
    
    override func configureLayout() {

        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaInsets)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }

    }
}





