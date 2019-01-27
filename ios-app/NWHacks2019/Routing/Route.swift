//
//  Route.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

protocol Route {}

enum AppRoute: Route {
    case dispatch
    case store
    case signUp
    case setup
}
