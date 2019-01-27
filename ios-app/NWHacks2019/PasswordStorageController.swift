//
//  PasswordStorageController.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import AlertHUDKit
import UIImageColors
import FavIcon
import SwiftKeychainWrapper

final class PasswordStorageView: CollectionView {
    override func viewDidLoad() {
        super.viewDidLoad()
        contentInset.top = 10
        backgroundColor = UIColor.black.lighter()
        registerCellClass(PasswordStoreCell.self)
    }
}

final class PasswordStoreCell: CollectionViewCell<PasswordStoreView> {
    func configure(for model: PasswordStore) {
        wrappedView.configure(for: model)
    }
}

final class PasswordStoreView: View, FeedbackGeneratable {
    private let topLabel = UILabel(style: Stylesheet.Labels.subheader) {
        $0.textColor = .white
    }
    private let bottomLabel = UILabel(style: Stylesheet.Labels.caption) {
        $0.textColor = .white
    }
    private let imageView = ImageView(image: nil)
    private var model: PasswordStore?


    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundColor = UIColor.black.lighter().lighter()
        imageView.contentMode = .scaleAspectFit
        addSubviews(imageView, topLabel, bottomLabel)

        imageView.anchor(left: leftAnchor, leftConstant: 8)
        imageView.anchorCenterYToSuperview()
        imageView.anchor(widthConstant: 30, heightConstant: 30)

        topLabel.anchor(imageView.topAnchor, left: imageView.rightAnchor, bottom: bottomLabel.topAnchor, right: rightAnchor, leftConstant: 8, rightConstant: 8)
        bottomLabel.anchor(topLabel.bottomAnchor, left: imageView.rightAnchor, bottom: imageView.bottomAnchor, right: rightAnchor, leftConstant: 8, rightConstant: 8)
        topLabel.anchorHeightToItem(bottomLabel)

        layer.cornerRadius = 8
        layer.addShadow(to: .bottom(3), opacity: 0.3, radius: 6, color: .darkGrayColor)
        anchorIfNeeded(heightConstant: 60)

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        gesture.minimumPressDuration = 1
        addGestureRecognizer(gesture)
    }

    func configure(for model: PasswordStore) {
        topLabel.text = model.name
        bottomLabel.text = model.url

        try? FavIcon.downloadPreferred(model.url) { [weak self] result in
            if case let .success(image) = result {
                self?.imageView.image = image
            }
        }

        self.model = model
    }

    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        gesture.isEnabled = false
        gesture.isEnabled = true
        UIPasteboard.general.string = model?.password
        generateSelectionFeedback()
        Ping(text: "Password copied to clipboard", style: .danger).show()
    }
}

final class PasswordStorageController: ViewModelController<PasswordStorageVM, PasswordStorageView> {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Password Store"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset Demo", style: .plain, target: self, action: #selector(reset))
    }

    override func bindToViewModel() {
        super.bindToViewModel()
         viewModel.bindTo(view: rootView)
    }

    @objc func add() {

    }

    @objc func reset() {
        KeychainWrapper.standard.removeAllKeys()
        AppRouter.shared.navigate(to: AppRoute.signUp)
    }
}
