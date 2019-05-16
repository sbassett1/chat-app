//
//  Message.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

struct Message: Decodable {
    public private(set) var _id: String
    public private(set) var messageBody: String
    public private(set) var userId: String
    public private(set) var channelId: String
    public private(set) var userName: String
    public private(set) var userAvatar: String
    public private(set) var userAvatarColor: String
    public private(set) var __v: Int?
    public private(set) var timeStamp: String
}
