//
//  Theme.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation
import UIKit.UIColor

enum Theme: Int {
    case light = 0
    case dark

    static var `default`: Theme {
        return .light
    }
}

extension UIColor {
    func adjustedForTheme(_ theme: Theme) -> UIColor {
        return theme == .dark ? self.darkModeColor() : self
    }
}
