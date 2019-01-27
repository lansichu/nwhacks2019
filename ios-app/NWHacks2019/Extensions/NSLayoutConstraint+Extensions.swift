//
//  NSLayoutConstraint+Extensions.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }

    @discardableResult
    func activated() -> NSLayoutConstraint {
        NSLayoutConstraint.activate([self])
        return self
    }
}
