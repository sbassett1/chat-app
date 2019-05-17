//
//  Constants.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

typealias BoolCallBack = (_ Success: Bool) -> ()
typealias DictCallBack = (_ typingUsers: [String: String]) -> ()
typealias MessageCallBack = (_ newMessage: Message) -> ()

public struct Constants {

    public struct URL {
        public static let base = "https://wack-chat-app.herokuapp.com/v1/"
        public static let register = "\(URL.base)account/register"
        public static let loginNewUser = "\(URL.base)account/login"
        public static let userAdd = "\(URL.base)user/add"
        public static let loginUserByEmail = "\(URL.base)user/byEmail/"
        public static let getChannels = "\(URL.base)channel/"
        public static let getMessages = "\(URL.base)message/byChannel/"
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

    public struct Socket {
        public static let stop = "stopType"
        public static let start = "startType"
        public static let userTyping = "userTypingUpdate"
        public static let channelCreated = "channelCreated"
        public static let messageCreated = "messageCreated"
        public static let newChannel = "newChannel"
        public static let newMessage = "newMessage"
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
        public static let messageCell = "messageCell"
    }

    public struct Colors {
        public static let placeholder = #colorLiteral(red: 0.3254901961, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5)
        public static let dark = "dark"
        public static let light = "light"
    }

    public struct Notifications {
        public static let userDataChanged = Notification.Name("userDataChanged")
        public static let channelsLoaded = Notification.Name("channelsLoaded")
        public static let channelSelected = Notification.Name("channelSelected")
    }

    public struct Fonts {
        public static let regular = "HelveticaNeue-Regular"
        public static let bold = "HelveticaNeue-Bold"
    }

    public struct Labels {
        public static let wack = "Wack"
        public static let login = "Login"
        public static let channels = "CHANNELS"
        public static let signIn = "Please Log In"
        public static let signInTo = "Sign in to add and join channels"
        public static let noChannels = "No Channels Joined Yet"
    }

    public struct Defaults {
        public static let username = "username"
        public static let email = "email"
        public static let password = "password"
        public static let name = "name"
        public static let description = "description"
        public static let avatar = "profileDefault"
        public static let color = "[0.5, 0.5, 0.5, 1]"
    }
}
