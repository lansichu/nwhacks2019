//
//  Model.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

protocol Model: Decodable, Equatable, IModel {
    
    associatedtype ID
    
    var id: ID { get set }
}

extension Model where ID == String {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Model where ID == UUID {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Model where ID == Int {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
