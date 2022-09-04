//
//  DetailViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import RealmSwift


protocol WriteTextDelegate {
    func sentText(_ text: String)
}


class DetailViewController: BaseViewController {
    
    
    let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }
    

    
    override func configure() {
        detailView.textView.becomeFirstResponder()
        configureData()
        configureNavigationBar()
        configureNavigationBarButtonItem()
    }
    
    let repository = MemoRepository()
    
    var memoObject: Memo?
    
    var mainTitle = ""
    var mainContent = ""
}







// MARK: - configure Methods
extension DetailViewController {
    
    func configureData() {
        guard let titleText = memoObject?.title else { return }
        guard let contentText = memoObject?.content else { return }
        detailView.textView.text = "\(titleText)\n\(contentText)"
    }
    
    func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = COLOR_BRANDI_PRIMARY
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    func configureNavigationBarButtonItem() {
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.rightBarButtonItem = completeButton
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        navigationItem.rightBarButtonItems = [completeButton, shareButton]
    }
    
    
    
    // MARK: - 저장버튼(1. didSelect로 왔을때(수정), 2. Write로 왔을때(작성)): 1번일경우 수정(update), 2번일경우 작성(add)
    @objc func completeButtonClicked() {
        
        guard let text = detailView.textView.text else { return }
        let splitedTextSubStringArray = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        let splitedTextStringArray = splitedTextSubStringArray.map { String($0) }
        
        guard let titleText = splitedTextStringArray.first else { return }
        guard let contentText = splitedTextStringArray.last else { return }
        mainTitle = titleText
        mainContent = contentText
        
        // MARK: - 작성 --> add
        if memoObject == nil {
            repository.addObject(newObject: Memo(title: mainTitle, content: mainContent, date: Date()))
        // MARK: - 수정 --> Update
        } else {
            repository.updatePost(updateObject: memoObject!, title: mainTitle, content: mainContent)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonClicked() {

        guard let text = detailView.textView.text else { return }
        
        var shareObject: [String] = []
        
        shareObject.append(text)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}

