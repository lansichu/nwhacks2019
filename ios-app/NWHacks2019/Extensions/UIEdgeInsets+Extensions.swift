//
//  UIEdgeInsets+Extensions.swift
//  NWHacks2019
//
//  Created Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }
}
