//
//  Constants.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

public struct Constants {

    public struct URL {
        public static let base = "https://wack-chat-app.herokuapp.com/v1/"
        public static let register = "\(URL.base)account/register"
        public static let loginNewUser = "\(URL.base)account/login"
        public static let userAdd = "\(URL.base)user/add"
        public static let loginUserByEmail = "\(URL.base)user/byEmail/"
        public static let getChannels = "\(URL.base)channel/"
    }

    public struct Header {
        public static let registerUser = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        public static func setupUser(_ authToken: String) -> [String: String] {
            return [
                "Authorization": "Bearer \(authToken)",
                "Content-Type": "application/json; charset=utf-8"
            ]
        }
    }

    public struct Body {
        public static func registerUser(email: String, password: String) -> [String: String] {
            return [
                "email": email.lowercased(),
                "password": password
            ]
        }
        public static func setupUser(name: String, email: String, avatarName: String, color: String) -> [String: String] {
            return [
                "name": name,
                "email": email.lowercased(),
                "avatarName": avatarName,
                "avatarColor": color
            ]
        }
    }

    public struct UserDefaults {
        public static let tokenKey = "token"
        public static let loggedInKey = "loggedIn"
        public static let userEmail = "userEmail"
    }

    public struct Segues {
        public static let toLogin = "toLogin"
        public static let toCreateAccount = "toCreateAccount"
        public static let unwindToChannel = "unwindToChannelVC"
        public static let toAvatarPicker = "toAvatarPicker"
    }

    public struct ReuseIdentifiers {
        public static let avatarCell = "avatarCell"
        public static let channelCell = "channelCell"
    }

    public struct Colors {
        public static let placeholder = #colorLiteral(red: 0.3254901961, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5)
    }

    public struct Notifications {
        public static let userDataChanged = Notification.Name("notifyUserDataChanged")
    }
}
