//
//  Schema.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import Foundation
import RealmSwift


class Memo: Object {
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var date: Date
    @Persisted var isFixed: Bool

    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content: String, date: Date) {
        self.init()
        self.title = title
        self.content = content
        self.date = date
        self.isFixed = false
    }
}
