//
//  RoundedView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class RoundedView: UIView, RoundableView {
    
    var roundingMethod: RoundingMethod = .complete {
        didSet {
            applyRounding()
        }
    }
    
    var roundedCorners: UIRectCorner = .allCorners {
        didSet {
            applyRounding()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyRounding()
    }
}
