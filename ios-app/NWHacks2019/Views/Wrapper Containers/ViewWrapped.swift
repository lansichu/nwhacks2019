//
//  ViewView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class ViewWrapped<ViewType: UIView>: View, IWrapperView {

    let wrappedView: ViewType
    var wrappedViewInsets: UIEdgeInsets = .zero {
        didSet {
            layoutSubviews()
        }
    }

    required override init(frame: CGRect) {
        wrappedView = ViewType(frame: frame)
        super.init(frame: frame)
        viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        wrappedView = ViewType(coder: aDecoder)!
        super.init(coder: aDecoder)
        viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview(wrappedView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        wrappedView.frame = bounds.inset(by: wrappedViewInsets)
    }
}

