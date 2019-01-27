//
//  Interface+Defaults.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift

extension IView {
    func viewWillAppear(_ animated: Bool) {
        interfaceSubviews.forEach { $0.viewWillAppear(animated) }
    }
    func viewDidAppear(_ animated: Bool) {
        interfaceSubviews.forEach { $0.viewDidAppear(animated) }
    }
    func viewWillDisappear(_ animated: Bool) {
        interfaceSubviews.forEach { $0.viewWillDisappear(animated) }
    }
    func viewDidDisappear(_ animated: Bool) {
        interfaceSubviews.forEach { $0.viewDidDisappear(animated) }
    }
}

extension IErrorPresenter {
    func presentError(_ error: IError, animated: Bool, completion: (() -> Void)?) {
        let alert = UIAlertController(title: error.title, message: error.body, preferredStyle: .alert)
        alert.addAction(.ok)
        present(alert, animated: true, completion: nil)
    }
}

extension IReusableView {
    func prepareForReuse() { }
}

extension IThemeable {
    func themeDidChange(_ theme: Theme) { }
}
