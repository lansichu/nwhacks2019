//
//  BaseService.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

class Service: NSObject, IService {

    // MARK: - Init

    override init() {
        super.init()
        serviceDidLoad()
    }

    func serviceDidLoad() {

    }
}
