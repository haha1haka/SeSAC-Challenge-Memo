//
//  Observable.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/10/13.
//

import Foundation
 
class Observable<T> {
    
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ completionHandler: @escaping ((T) -> Void)) {
        completionHandler(value)
        listener = completionHandler
    }
}
