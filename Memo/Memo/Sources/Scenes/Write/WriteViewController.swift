//
//  WriteViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit



class WriteViewController: BaseViewController {
    
    
    let writeView = WriteView()
    
    override func loadView() {
        self.view = writeView
    }
    
    
    
    override func configure() {
        configureNavigationBarButtonItem()
        navigationItem.largeTitleDisplayMode = .never
    }
}








// MARK: - configure Methods
extension WriteViewController {
    func configureNavigationBarButtonItem() {
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.rightBarButtonItem = completeButton
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        navigationItem.rightBarButtonItems = [completeButton, shareButton]
    }
    
    @objc func completeButtonClicked() {
        guard let text = writeView.textView.text else { return }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func shareButtonClicked() {
        //액치비티 고고 ㄱㄷㄱㄷ
    }
    
}
