//
//  ViewModel.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation
import RxSwift

typealias ViewModel = BaseViewModel & IViewModel

class BaseViewModel: NSObject {

    // MARK: - Properties

    let appViewModel: AppViewModel

    required init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        super.init()
        viewModelDidLoad()
    }

    func viewModelDidLoad() {

    }
}
