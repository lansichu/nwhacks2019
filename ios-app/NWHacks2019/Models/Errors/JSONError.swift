//
//  JSONError.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

enum JSONError: Error {
    case decodingFailed
    case serializationFailed
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Response did not match decodable type"
        case .serializationFailed:
            return "Response was not a valid JSON object"
        }
    }
}
