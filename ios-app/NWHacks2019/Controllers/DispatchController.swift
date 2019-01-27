//
//  DispatchController.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import RxSwift

final class DispatchController: Controller<LoadingView> {
    let disposeBag = DisposeBag()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dispatch()
    }

    private func dispatch() {
        EncryptionService.shared.verify().subscribe(onCompleted: {
            AppRouter.shared.navigate(to: AppRoute.store)
        }, onError: { _ in
            AppRouter.shared.navigate(to: AppRoute.setup)
        }).disposed(by: disposeBag)
    }

}
