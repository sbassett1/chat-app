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
        public static let base_url = "https://wack-chat-app.herokuapp.com/v1/"
        public static let url_register = "\(URL.base_url)account/register"
        public static let url_login = "\(URL.base_url)account/login"
        public static let header = ["Content-Type": "application/json; charset=utf-8"]
        public static func body(email: String, password: String) -> [String: String] {
            return [
                "email": email,
                "password": password
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
    }
}
