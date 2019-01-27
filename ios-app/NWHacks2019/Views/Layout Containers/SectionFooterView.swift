//
//  SectionFooterView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

class SectionFooterView<ViewType: UIView>: View {

    let centerView = ViewType()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview(centerView)

        let xInset = Stylesheet.Layout.Padding.edgeLeadingTrailing
        let yInset = Stylesheet.Layout.Padding.edgeTopBottom

        centerView.anchorIfNeeded(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: xInset, bottomConstant: yInset, rightConstant: xInset)
        centerView.anchorIfNeeded(topAnchor, topConstant: yInset)
        centerView.anchorCenterXToSuperview()

        heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
            .withPriority(.defaultHigh)
            .activated()
    }

    override func themeDidChange(_ theme: Theme) {
        super.themeDidChange(theme)
        backgroundColor = .groupTableViewBackground
    }
}
