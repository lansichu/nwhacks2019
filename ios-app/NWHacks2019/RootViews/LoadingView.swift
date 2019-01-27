//
//  LoadingView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit

final class LoadingView: View {

    private let activityIndicator = ActivitySpinnerIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor = .black
        activityIndicator.tintColor = .lightGrayColor
        addSubview(activityIndicator)
        activityIndicator.anchorCenterToSuperview()
        activityIndicator.anchor(widthConstant: 50, heightConstant: 50)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
}
