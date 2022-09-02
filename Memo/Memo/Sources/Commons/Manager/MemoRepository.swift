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
//    func fetchFilterFixed() -> Results<Memo>
//    func fetchFilterNonFixed() -> Results<Memo>
//    func fetchDate(date: Date) -> Results<Memo>
}


class MemoRepository: MemoRepositoryType {
    
    
    
    let localRealm = try! Realm()
    
    
// MARK: - Create, Update
    
    // MARK: - add
    func addObject(newObject: Memo) {
        try! localRealm.write {
            localRealm.add(newObject)
        }
    }
    // MARK: - update(핀 토글)
    func updatePin(updateObject: Memo, isFiexd: Bool) {
        try! localRealm.write {
            updateObject.isFixed = isFiexd
        }
    }
    
    
    
    
    
    
    
// MARK: - 패치

    

    // MARK: - 패치(날짜별로)
    func fetch() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    
    // MARK: - 패치필터(고정,비고정)
    func fetchFilter(in object: Results<Memo>, isFixed: Bool) -> Results<Memo> {
        return object.filter("isFixed == \(isFixed)").sorted(byKeyPath: "date", ascending: false)
    }
    
    
    // MARK: - 패치필터(검색)
    func fetchFilterSearchedText(in object: Results<Memo>, text: String) -> Results<Memo> {
        return object.filter("content  CONTAINS[c] '\(text)'").sorted(byKeyPath: "date", ascending: false)
    }

    
    
    
    
    
    
    
    

    
    
    
    
    // date: 22/08//26 00분 00초 가 들어옴
    //func fetchDate(date: Date) -> Results<Memo> {
    //    // %@ --> NSPredicate문법
    //    return localRealm.objects(Memo.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date))
    //}
    
    
    
    
}
