//
//  UserDataService.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

class UserDataService {

    static let instance = UserDataService()

    public private(set) var color = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    public private(set) var id = ""

    func setUserData(color: String,
                             avatarName: String,
                             email: String,
                             name: String,
                             id: String) {
        self.color = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
        self.id = id
    }

    private func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
}
