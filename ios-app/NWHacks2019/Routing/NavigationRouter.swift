//
//  NavigationRouter.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import Swinject

class NavigationCoordinator: Coordinator {

    // MARK: - Properties

    var mainController: UIViewController {
        return navigationController
    }

    var container: Container

    let navigationController: NavigationController

    // MARK: - Init

    init(in container: Container) {
        self.container = container
        self.navigationController = NavigationController()
    }
}
