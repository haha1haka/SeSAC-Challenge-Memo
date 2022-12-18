//
//  MainViewModel.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/10/13.
//

import Foundation
import RealmSwift

class MainViewModel {
    
    let repository = MemoRepository()
    
    var memo: Observable<[[Memo]]> = Observable([])
    
    func numberOfSections() -> Int {
        return memo.value.count
    }
    
    func numberOfRowsInSection(at section: Int) -> Int {
        return memo.value[section].count
    }
    
    
}


