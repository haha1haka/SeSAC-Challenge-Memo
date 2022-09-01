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
    func fetchFilterFixed() -> Results<Memo>
    func fetchFilterNonFixed() -> Results<Memo>
    func fetchDate(date: Date) -> Results<Memo>
}


class MemoRepository: MemoRepositoryType {
    
    
    
    let localRealm = try! Realm()
    
    
    
    
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
    func fetch() -> Results<Memo> {
        return localRealm.objects(Memo.self)
    }
    
    // MARK: - 고정
    func fetchFilterFixed() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isFixed == true").sorted(byKeyPath: "date", ascending: false)
    }
    
    // MARK: - 고정안됨
    func fetchFilterNonFixed() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isFixed == false").sorted(byKeyPath: "date", ascending: false)
    }
    
    
    
    
    
    
    
    
    
    
    
    // date: 22/08//26 00분 00초 가 들어옴
    func fetchDate(date: Date) -> Results<Memo> {
        // %@ --> NSPredicate문법
        return localRealm.objects(Memo.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date))
    }
    
    
    
    
}
