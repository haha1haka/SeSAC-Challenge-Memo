//
//  IntroView.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class IntroView: BaseView {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_BRANDI_PRIMARY
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    let label: UILabel = {
        let view = UILabel()
        
        
        view.text = """
                    처음 오셨군요!
                    환영합니다 :)
                    
                    당신만의 메모를 작성하고
                    관리해보세요!
                    """
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 25, weight: .bold)
        view.textColor = .label
        return view
    }()
    
    let button: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        view.setTitle("확인", for: .normal)
        view.backgroundColor = Color.memoYellow
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    

    override func configure() {
        self.addSubview(containerView)
        [label, button].forEach { self.addSubview($0) }
    }
    
    
    
    override func setConstraints() {

        containerView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.center.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(10)
            $0.leading.trailing.equalTo(containerView).inset(20)
            $0.bottom.equalTo(button.snp.top).offset(-10)
//            $0.height.equalTo(100)
        }
        button.snp.makeConstraints {
            $0.leading.equalTo(containerView).inset(20)
            $0.trailing.equalTo(containerView).inset(20)
            $0.bottom.equalTo(containerView).offset(-25)
            $0.height.equalTo(55)
        }
        
    }
}
