//
//  Color.swift
//  Memo
//
//  Created by HWAKSEONG KIM on 2022/08/31.
//

import UIKit

enum Color {
    static let memoYellow = UIColor(red: 252/255, green: 204/255, blue: 29/255, alpha: 1)
}


let COLOR_BRANDI_PRIMARY: UIColor = {
    if #available(iOS 13, *) {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor(red: 242/255, green: 241/255, blue: 247/255, alpha: 1)
            }
        }
    } else {
        
        return UIColor(red: 252/255, green: 204/255, blue: 29/255, alpha: 1)
    }
}()
