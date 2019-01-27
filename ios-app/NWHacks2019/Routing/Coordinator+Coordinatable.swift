//
//  Coordinator+Coordinatable.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import Swinject

protocol Coordinator {
    var mainController: UIViewController { get }
    var container: Container { get set }
}

protocol Coordinatable {
    associatedtype RouteType: Route
    func navigate(to route: RouteType)
}
