//
//  ImageView.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import Kingfisher

class ImageView: UIImageView, IView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewDidLoad()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        viewDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewDidLoad()
    }

    func viewDidLoad() {
        subscribeToThemeChanges()
        contentMode = .scaleAspectFill
    }

    func setImage(with resource: Resource) {
        kf.setImage(with: resource)
    }

    // MARK: - Theme Updates

    func themeDidChange(_ theme: Theme) {

    }
}
