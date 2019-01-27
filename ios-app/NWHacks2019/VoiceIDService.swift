//
//  VoiceIDService.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation
import AlertHUDKit
import SwiftKeychainWrapper

struct VoiceIDResponse: Decodable {
    let result: String
    let confidence: String
    let phrase: String

    var isAuthed: Bool {
        return result == "Accept"
    }
}

final class VoiceIDService: Service {
    static var shared = VoiceIDService()

    func authenticate(url: URL) -> Completable {
        return Completable.create { event in

            guard let id = KeychainWrapper.standard.string(forKey: "id") else {
                event(.error(JSONError.decodingFailed))
                return Disposables.create()
            }

            let headers = [
                "Content-Type": "application/octet-stream",
                "Ocp-Apim-Subscription-Key": "17d0ba94626641f29ada3e5bdd0d19e5"

            ]

            let recording = try! Data(contentsOf: url)
            let request = NSMutableURLRequest(url: URL(string: "https://westus.api.cognitive.microsoft.com/spid/v1.0/verify?verificationProfileId=\(id)")!,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = recording

            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                print(response)
                if let data = data {

                    if let response = try?  JSONDecoder().decode(VoiceIDResponse.self, from: data) {

                        response.isAuthed
                            ? event(.completed)
                            : event(.error(Err.custom("Authorization Failed")))


                    } else if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String] {

                        if let err = json?["error"] as? [String: String] {
                            let message = err["message"] as? String
                            DispatchQueue.main.async {
                                Ping(text: message ?? "Authorization Failed", style: .danger).show()
                            }
                            event(.error(Err.custom(message ?? "Authorization Failed")))
                        } else {
                            event(.error(Err.custom("Authorization Failed")))
                        }
                    } else {
                        event(.error(Err.custom("Authorization Failed")))
                    }

                } else {
                    event(.error(Err.custom("Authorization Failed")))
                }
            }).resume()

            return Disposables.create()
        }
    }
}
