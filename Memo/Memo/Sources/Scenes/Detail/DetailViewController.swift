//
//  DetailViewController.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }

    override func configure() {
        detailView.textView.becomeFirstResponder()
        configureData() // 넘어온 data textView에 세팅
        configureNavigationBar() //네비게이션 바 세팅
        configureNavigationBarButtonItem() // 네비게이션 바 아이템 세팅
    }
    
    let repository = MemoRepository()
    
    var memoObject: Memo? // Main didSelect에서만 넘겨준 객체
    
    var mainTitle = ""
    var mainContent = ""
}









// MARK: - configure Methods
extension DetailViewController {
    
    
    //받아온 객체에서 title 과 content 빼서 textViewd에 세팅
    func configureData() {
        guard let titleText = memoObject?.title else { return }
        guard let contentText = memoObject?.content else { return }
        detailView.textView.text = "\(titleText)\n\(contentText)"
    }
    
    
    
    //네비게이션 바 appearance 세팅
    func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = COLOR_BRANDI_PRIMARY
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    
    
    //네비게이션 바 버튼 아이템 세팅
    func configureNavigationBarButtonItem() {
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.rightBarButtonItem = completeButton
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        navigationItem.rightBarButtonItems = [completeButton, shareButton]
    }
    
    
    
    // MARK: - 저장버튼 1. didSelect로 왔을때(수정), 2. Write로 왔을때(작성)
    @objc func completeButtonClicked() {
        
        guard let text = detailView.textView.text else { return }
        let splitedTextSubStringArray = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        let splitedTextStringArray = splitedTextSubStringArray.map { String($0) }
        
        if splitedTextStringArray.count == 1 {
            guard let titleText = splitedTextStringArray.first else { return }
            mainTitle = titleText
            mainContent = ""
        } else {
            guard let titleText = splitedTextStringArray.first else { return }
            guard let contentText = splitedTextStringArray.last else { return }
            mainTitle = titleText
            mainContent = contentText
        }
        
        

        // MARK: - 작성 --> add
        //받아온 객체가 있으면
        if memoObject == nil {
            repository.addObject(newObject: Memo(title: mainTitle, content: mainContent, date: Date()))
            
        // MARK: - 수정 --> Update
        } else { // 받아온 객체가 없기 때문에, writeButton을 통해서온 것, 수정
            repository.updatePost(updateObject: memoObject!, title: mainTitle, content: mainContent)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    //- UIActivityViewController(공유)
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

