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
        public static let login = "\(URL.base)account/login"
        public static let user_add = "\(URL.base)user/add"
    }

    public struct Header {
        public static let register_user = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        public static let setup_user = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
    }

    public struct Body {
        public static func register_user(email: String, password: String) -> [String: String] {
            return [
                "email": email,
                "password": password
            ]
        }
        public static func setup_user(name: String, email: String, avatarName: String, color: String) -> [String: String] {
            return [
                "name": name,
                "email": email,
                "avatarName": avatarName,
                "avatarColor": color
            ]
        }
    }

    public struct UserDefaults {
        public static let token_key = "token"
        public static let logged_in_key = "loggedIn"
        public static let user_email = "userEmail"
    }

    public struct Segues {
        public static let to_login = "toLogin"
        public static let to_create_account = "toCreateAccount"
        public static let unwind_to_channel = "unwindToChannelVC"
        public static let to_avatar_picker = "toAvatarPicker"
    }

    public struct ReuseIdentifiers {
        public static let avatarCell = "avatarCell"
    }

    public struct Colors {
        public static let placeholder = #colorLiteral(red: 0.3254901961, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5)
    }
}
