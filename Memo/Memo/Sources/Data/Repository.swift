//
//  memoRepository.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/09/01.
//

import Foundation
import RealmSwift

protocol Repository {
    func fetch() -> Results<Memo>
    func fetchFilter(in object: Results<Memo>, isFixed: Bool) -> Results<Memo>
    func fetchFilterSearchedText(in object: Results<Memo>, text: String) -> Results<Memo>
}

class MemoRepository: Repository {
    
    
    let database = try! Realm()
    
    
    func addObject(newObject: Memo) {
        try! database.write {
            database.add(newObject)
        }
    }
    
    func updatePin(updateObject: Memo, isFiexd: Bool) {
        try! database.write {
            updateObject.isFixed = isFiexd
        }
    }
    
    func updatePost(updateObject: Memo, title: String, content: String) {
        try! database.write {
            updateObject.title = title
            updateObject.content = content
        }
    }
    
    func deletePost(deletedObject: Memo) {
        try! database.write {
            database.delete(deletedObject)
        }
    }
    
    
    
    
    
    func fetch() -> Results<Memo> {
        return database.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    
    
    func fetchFilter(in object: Results<Memo>, isFixed: Bool) -> Results<Memo> {
        return object.filter("isFixed == \(isFixed)").sorted(byKeyPath: "date", ascending: false)
    }
    
    
    
    func fetchFilterSearchedText(in object: Results<Memo>, text: String) -> Results<Memo> {
        return object.filter("content  CONTAINS[c] '\(text)' OR title CONTAINS[c]  '\(text)'").sorted(byKeyPath: "date", ascending: false)
    }

    
}
