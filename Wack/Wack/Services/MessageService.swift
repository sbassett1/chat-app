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
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel: Channel?
    let userAuth = AuthService.shared

    // MARK: Global Functions

    func findAllChannels(completion: @escaping BoolCallBack) {

        Alamofire.request(Constants.URL.getChannels,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: Constants.Header.setupUser(self.userAuth.authToken)).responseJSON { response in

                            if response.result.error == nil {

                                // Usins new swift approach parsing but requires exact
                                // data model with exact names expected from response

                                guard let data = response.data else { return }
                                do {
                                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                                } catch let error {
                                    debugPrint(error as Any)
                                }

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

                                NotificationCenter.default.post(name: Constants.Notifications.channelsLoaded, object: nil)
                                completion(true)
                            } else {
                                debugPrint(response.result.error as Any)
                                completion(false)
                            }
        }
    }

    func findAllMessagesForChannel(channelId: String, completion: @escaping BoolCallBack) {

        Alamofire.request("\(Constants.URL.getMessages)\(channelId)",
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: Constants.Header.setupUser(self.userAuth.authToken)).responseJSON { response in
                            if response.result.error == nil {
                                self.clearMessages()
                                guard let data = response.data else { return }
                                do {
                                    self.messages = try JSONDecoder().decode([Message].self, from: data)
                                } catch let error {
                                    debugPrint(error as Any)
                                }
                                print(self.messages)
                                completion(true)
                            } else {
                                debugPrint(response.result.error as Any)
                                completion(false)
                            }
        }
    }

    func clearChannels() {
        self.channels.removeAll()
    }

    func clearMessages() {
        self.messages.removeAll()
    }
}
