//
//  MessageService.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class MessageService {

    static let shared = MessageService()

    // MARK: Variables

    var channels = [Channel]()

    // MARK: Global Functions

    func findAllChannels(completion: @escaping CompletionHandler) {

        Alamofire.request(Constants.URL.getChannels,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: Constants.Header.setupUser(AuthService.shared.authToken)).responseJSON { response in

                            if response.result.error == nil {

                                // Usins new swift approach parsing but requires exact
                                // data model with exact names expected from response

                                guard let data = response.data else { return }
                                do {
                                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                                } catch let error {
                                    debugPrint(error as Any)
                                }
                                print(self.channels)

                                // SwiftyJSON example below

//                                guard let data = response.data,
//                                    let json = JSON(data: data).array else { return }
//
//                                for item in json {
//                                    let name = item["name"].stringValue
//                                    let description = item["description"].stringValue
//                                    let id = item["_id"].stringValue
//                                    let channel = Channel(name: name,
//                                                          description: description,
//                                                          id: id)
//                                    self.channels.append(channel)
//                                }

                                completion(true)
                            } else {
                                completion(false)
                                debugPrint(response.result.error as Any)
                            }
        }
    }
}
