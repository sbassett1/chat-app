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
                    completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }

    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { dataArray, _ in
            guard let name = dataArray[0] as? String,
                let description = dataArray[1] as? String,
                let id = dataArray[2] as? String else { return }

            let newChannel = Channel(_id: id, name: name, description: description, __v: nil)
            MessageService.shared.channels.append(newChannel)
            completion(true)
        }
    }
}
