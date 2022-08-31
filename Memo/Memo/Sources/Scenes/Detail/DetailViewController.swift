//
//  DetailViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit

class DetailViewController: BaseViewController {
    
    
    let detailView = DetailView()
    
    override func loadView() {
        
        self.view = detailView
    }
    
    override func configure() {
        configureNavigationBar()
        configureNavigationBarButtonItem()
        
    }
}

extension DetailViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        detailView.textView.becomeFirstResponder()
        
    }
}


extension DetailViewController {
    func configureNavigationBar() {
        
    }
    
    
    
    func configureNavigationBarButtonItem() {
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.rightBarButtonItem = completeButton
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        navigationItem.rightBarButtonItems = [shareButton, completeButton]
    }
    
    @objc func completeButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    @objc func shareButtonClicked() {
        //액치비티 고고 ㄱㄷㄱㄷ
    }
    
    
    
}


extension DetailViewController {
    
}



extension DetailViewController {
    
}
