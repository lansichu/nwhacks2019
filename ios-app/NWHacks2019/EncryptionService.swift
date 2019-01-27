//
//  EncryptionService.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation
import RxSwift
import SwiftKeychainWrapper
import CryptoSwift
import AlertHUDKit

enum Err: LocalizedError {
    case custom(String)

    var localizedDescription: String {
        switch self {
        case .custom(let err):
            return err
        }
    }
}

final class EncryptionService: Service {
    static var shared = EncryptionService()

    override func serviceDidLoad() {
        super.serviceDidLoad()
    }

    func verify() -> Completable {
        guard let id = KeychainWrapper.standard.string(forKey: "id") else {
            return Completable.error(JSONError.decodingFailed)
        }
        return NetworkService.shared.request(.getUser(userId: id), decodeAs: User.self).asCompletable()
    }

    func start(url: URL) -> Completable {
        guard let id = KeychainWrapper.standard.string(forKey: "id") else {
            return Completable.error(JSONError.decodingFailed)
        }

        let privateKey = String.randomOfLength(32)
        KeychainWrapper.standard.set(privateKey, forKey: "key")

        return Completable.create { event in
            let headers = [
                "Content-Type": "application/octet-stream",
                "Ocp-Apim-Subscription-Key": "17d0ba94626641f29ada3e5bdd0d19e5"

            ]

            let recording = try! Data(contentsOf: url)
            let request = NSMutableURLRequest(url: URL(string: "https://westus.api.cognitive.microsoft.com/spid/v1.0/verificationProfiles/\(id)/enroll")!,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = recording


            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                    event(.error(error))
                } else {
                    if let data = data {
                        let err = String(data: data, encoding: .utf8) ?? "Audio recording too short"
                        print(err)
                        print(response)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String] {
                                print(json)
                                let message = json?["message"] as? String
                                DispatchQueue.main.async {
                                    Ping(text: message ?? "Too Noisy", style: .danger).show()
                                }
                            }
                            event(.error(Err.custom(err)))
                        } else {
                            event(.completed)
                        }
                    } else {
                        event(.completed)
                    }
                }
            }).resume()
            return Disposables.create()
        }
    }
}
