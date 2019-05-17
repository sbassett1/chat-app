//
//  SocketService.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import SocketIO
import UIKit

class SocketService: NSObject {

    static let shared = SocketService()

    // MARK: Variables

    let manager: SocketManager
    let socket: SocketIOClient
    let comms = MessageService.shared

    override init() {
        // swiftlint:disable:next force_unwrapping
        self.manager = SocketManager(socketURL: URL(string: Constants.URL.base)!)
        self.socket = manager.defaultSocket
        super.init()
    }

    // MARK: Global Functions

    func esablishConnection() {
        self.socket.connect()
    }

    func closeConnection() {
        self.socket.disconnect()
    }

    func addChannel(channelName: String,
                    channelDescription: String,
                    completion: @escaping BoolCallBack) {
        self.socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }

    func getChannel(completion: @escaping BoolCallBack) {
        self.socket.on("channelCreated") { dataArray, _ in
            guard let name = dataArray[0] as? String,
                let description = dataArray[1] as? String,
                let id = dataArray[2] as? String else { return }

            let newChannel = Channel(_id: id, name: name, description: description, __v: nil)
            self.comms.channels.append(newChannel)
            completion(true)
        }
    }

    func addMessage(messageBody: String,
                    userId: String,
                    channelId: String,
                    completion: @escaping BoolCallBack) {
        let user = UserDataService.shared
        self.socket.emit("newMessage",
                         messageBody,
                         userId,
                         channelId,
                         user.name,
                         user.avatar,
                         user.color)
        completion(true)
    }

    func getChatMessage(completion: @escaping BoolCallBack) {
        self.socket.on("messageCreated") { dataArray, _ in
            guard let message = dataArray[0] as? String,
                let channelId = dataArray[2] as? String,
                let name = dataArray[3] as? String,
                let avatar = dataArray[4] as? String,
                let color = dataArray[5] as? String,
                let id = dataArray[6] as? String,
                let timeStamp = dataArray[2] as? String else { return }

            if channelId == self.comms.selectedChannel?._id && AuthService.shared.isLoggedIn {
                let newMessage = Message(_id: id,
                                         messageBody: message,
                                         userId: nil,
                                         channelId: channelId,
                                         userName: name,
                                         userAvatar: avatar,
                                         userAvatarColor: color,
                                         __v: nil,
                                         timeStamp: timeStamp)
                self.comms.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func getTypingUsers(_ completion: @escaping DictCallBack) {
        self.socket.on("userTypingUpdate") { dataArray, _ in
            guard let typingUsers = dataArray.first as? [String: String] else { return }
            completion(typingUsers)
        }
    }

}
