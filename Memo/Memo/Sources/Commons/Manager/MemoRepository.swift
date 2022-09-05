//
//  memoRepository.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/09/01.
//

import Foundation
import RealmSwift

protocol MemoRepositoryType {
    func fetch() -> Results<Memo>
    func fetchFilter(in object: Results<Memo>, isFixed: Bool) -> Results<Memo>
    func fetchFilterSearchedText(in object: Results<Memo>, text: String) -> Results<Memo>
}

class MemoRepository: MemoRepositoryType {
    
    
    let localRealm = try! Realm()
    
    
    // MARK: - CRUD
    //-  Create
    func addObject(newObject: Memo) {
        try! localRealm.write {
            localRealm.add(newObject)
        }
    }
    //- update(핀 토글)
    func updatePin(updateObject: Memo, isFiexd: Bool) {
        try! localRealm.write {
            updateObject.isFixed = isFiexd
        }
    }
    //- update(게시글 수정)
    func updatePost(updateObject: Memo, title: String, content: String) {
        try! localRealm.write {
            updateObject.title = title
            updateObject.content = content
        }
    }
    
    //- Delete
    func deletePost(deletedObject: Memo) {
        try! localRealm.write {
            localRealm.delete(deletedObject)
        }
    }
    
    
    
    
    
    
    
    // MARK: - 패치
    //- 패치(날짜별로)
    func fetch() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    
    //- 패치필터(고정,비고정)
    func fetchFilter(in object: Results<Memo>, isFixed: Bool) -> Results<Memo> {
        return object.filter("isFixed == \(isFixed)").sorted(byKeyPath: "date", ascending: false)
    }
    
    
    //- 패치필터(검색)
    func fetchFilterSearchedText(in object: Results<Memo>, text: String) -> Results<Memo> {
        return object.filter("content  CONTAINS[c] '\(text)' OR title CONTAINS[c]  '\(text)'").sorted(byKeyPath: "date", ascending: false)
    }

    
}
