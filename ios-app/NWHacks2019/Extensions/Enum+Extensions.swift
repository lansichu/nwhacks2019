//
//  Enum+Extensions.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 3/11/18.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}
