//
//  HTTPRequest.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation
import Alamofire
import Moya

enum HttpRequest {
    case createUser
    case getUser(userId: String)
    case updateUser(userId: String, fname: String, lname: String, phone: String)
}

extension HttpRequest {
    var priority: DispatchQoS.QoSClass {
        return .userInitiated
    }
}

extension HttpRequest: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://bobbyb.lib.id/voiceauth@dev")!
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/user/create/"
        case .getUser(let id):
            return "/user/getUser?userId=\(id)"
        case .updateUser(let userId, let fname, let lname, let phone):
            return "/user/updateUser"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser, .getUser, .updateUser:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .createUser, .getUser:
            return .requestPlain
        case .updateUser(let userId, let fname, let lname, let phone):
            let name1 = fname.isEmpty ? "F_NAME" : fname
            let name2 = lname.isEmpty ? "L_NAME" : lname
            let ph = phone.isEmpty ? "6043556292" : phone
            return .requestParameters(parameters: ["userid": userId, "fname":name1, "lname":name2,"phone":ph,"email":"someone@mail.com"], encoding: URLEncoding(destination: .queryString, arrayEncoding: .brackets, boolEncoding: .literal))
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    var validationType: Moya.ValidationType {
        return .none
    }
}

extension HttpRequest: AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType {
        return .none
    }
}
