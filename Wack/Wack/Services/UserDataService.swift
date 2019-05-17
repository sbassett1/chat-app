//
//  UserDataService.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

class UserDataService {

    static let shared = UserDataService()

    // MARK: Variables

    let auth = AuthService.shared
    let comms = MessageService.shared

    public private(set) var color = ""
    public private(set) var avatar = ""
    public private(set) var email = ""
    public private(set) var name = ""
    public private(set) var id = ""

    // MARK: Global Functions

    func setUserData(color: String,
                     avatar: String,
                     email: String,
                     name: String,
                     id: String) {
        self.color = color
        self.avatar = avatar
        self.email = email
        self.name = name
        self.id = id
    }

    func setAvatarName(avatar: String) {
        self.avatar = avatar
    }

    func logoutUser() {
        self.color = ""
        self.avatar = ""
        self.email = ""
        self.name = ""
        self.id = ""
        self.auth.isLoggedIn = false
        self.auth.userEmail = ""
        self.auth.authToken = ""
        self.comms.clearChannels()
        self.comms.clearMessages()
    }
}
