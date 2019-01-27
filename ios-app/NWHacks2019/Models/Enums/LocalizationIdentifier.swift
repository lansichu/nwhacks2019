//
//  LocalizationIdentifier.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation

enum LocalizableIdentifier: String {

    // Common
    case ok
    case done
    case cancel
    case delete
    case search
    case save

    // Auth
    case email
    case password
    case passwordVerify
    case phoneNumber
    case termsOfUse
    case termsOfUsePrompt
    case eula
    case signUpPrompt
    case signUpHere
    case forgotPassword
    case login
    case signUp
    case firstLastName
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}

extension String {
    
    static func localize(_ identifier: LocalizableIdentifier) -> String {
        return identifier.localized
    }
}
