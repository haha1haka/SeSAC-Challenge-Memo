//
//  WriteViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit

protocol WriteTextDelegate {
    func sentText(_ text: String)
}




class WriteViewController: BaseViewController {
    
    
    let writeView = WriteView()
    
    override func loadView() {
        self.view = writeView
    }
    
    var delegate: WriteTextDelegate?
    
    override func configure() {
        configureNavigationBarButtonItem()
        navigationItem.largeTitleDisplayMode = .never
    }
}










// MARK: - viewWillAppear
extension WriteViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        
    }
    
    
    
    
    
}





// MARK: - configure Methods
//extension WriteViewController {
//    func configureNavigationBarButtonItem() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonClicked))
//        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonClicked))
//        self.navigationItem.backBarButtonItem = backBarButtonItem


//    }
//    @objc func backButtonClicked() {
//
//        navigationController?.popViewController(animated: true)
//    }

//}



extension WriteViewController {
    func configureNavigationBarButtonItem() {
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.rightBarButtonItem = completeButton
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        navigationItem.rightBarButtonItems = [completeButton, shareButton]
    }
    
    @objc func completeButtonClicked() {
        guard let text = writeView.textView.text else { return }
        delegate?.sentText(text)
        navigationController?.popViewController(animated: true)
    }
    @objc func shareButtonClicked() {
        //액치비티 고고 ㄱㄷㄱㄷ
    }
    
}
