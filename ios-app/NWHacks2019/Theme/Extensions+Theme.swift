//
//  Extensions+Theme.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

extension UIColor {

    static var primaryColor: UIColor {
        return UIColor(red: 0, green: 1, blue: 0.5, alpha: 1)
    }

    static var secondaryColor: UIColor {
        return primaryColor.darker()
    }

    static var tertiaryColor: UIColor {
        return primaryColor.lighter()
    }

    static var backgroundColor: UIColor {
        return UIColor.white
    }

    static var offWhiteColor: UIColor {
        return UIColor(white: 0.96, alpha: 1)
    }

    static var grayColor: UIColor {
        return UIColor.gray
    }

    static var darkGrayColor: UIColor {
        return UIColor.darkGray
    }

    static var lightGrayColor: UIColor {
        return UIColor(white: 0.922, alpha: 1)
    }

    static var shadowColor: UIColor {
        return UIColor.black
    }

    static var blackColor: UIColor {
        return UIColor.black
    }
}
