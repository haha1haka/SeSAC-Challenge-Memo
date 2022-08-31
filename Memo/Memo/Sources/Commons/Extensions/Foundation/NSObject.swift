//
//  NSObject.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: Self.self)
    }
}
