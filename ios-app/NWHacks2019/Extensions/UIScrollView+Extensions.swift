//
//  UIScrollView+Extensions.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

extension UIScrollView {
    func reset() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentOffset = .zero
        }
    }

    func scroll(to view: UIView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentOffset.y = view.frame.origin.y + 32
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentSize.height += 416
        }
        scroll(to: textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentSize.height -= 416
        }
    }
}
