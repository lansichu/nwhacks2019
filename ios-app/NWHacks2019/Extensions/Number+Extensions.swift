//
//  Number+Extensions.swift
//  NWHacks2019
//
//  Created Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

extension Double {
    
    func toDollars() -> String {
        return String(format: "$%.02f", self)
    }
    
    func roundTwoDecimal() -> String {
        return String(format: "%.02f", self)
    }
    
}
