//
//  IntroView.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import SnapKit

class IntroView: BaseView {
    
//    let lootView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
//        return view
//    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    

    let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 12
        view.axis = .vertical
        view.backgroundColor = .clear
//        view.distribution = .
        return view
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        
        view.text = """
                    처음 오셨군요!
                    환영합니다 :)
                    
                    당신만의 메모를 작성하고
                    관리해보세요!
                    """
        view.font = .systemFont(ofSize: 25, weight: .bold)
        view.textColor = .white
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
//        self.addSubview(lootView)
        self.addSubview(containerView)
        containerView.addSubview(stackView)
        [textView, button].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
//        lootView.snp.makeConstraints {
//            $0.edges.equalTo(self)
//        }
        containerView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(containerView).inset(10)
        }
        textView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(containerView).inset(20)
            $0.height.equalTo(100)
        }
        button.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(stackView).inset(20)
            $0.height.equalTo(55)
        }
        
    }
    
    
    
    
}
