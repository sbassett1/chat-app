//
//  AuthService.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class AuthService {

    static let instance = AuthService()

    private let defaults = UserDefaults.standard

    var isLoggedIn: Bool {
        get {
            return self.defaults.bool(forKey: Constants.UserDefaults.loggedInKey)
        }
        set {
            self.defaults.set(newValue, forKey: Constants.UserDefaults.loggedInKey)
        }
    }

    var authToken: String {
        get {
            return self.defaults.value(forKey: Constants.UserDefaults.tokenKey) as! String
        }
        set {
            self.defaults.set(newValue, forKey: Constants.UserDefaults.tokenKey)
        }
    }

    var userEmail: String {
        get {
            return self.defaults.value(forKey: Constants.UserDefaults.userEmail) as! String
        }
        set {
            self.defaults.set(newValue, forKey: Constants.UserDefaults.userEmail)
        }
    }

    func registerUser(email: String,
                      password: String,
                      completion: @escaping CompletionHandler) {

        let body = Constants.Body.register_user(email: email, password: password)

        Alamofire.request(Constants.URL.register,
                          method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: Constants.Header.registerUser).responseString { response in

                            if response.result.error == nil {
                                completion(true)
                            } else {
                                completion(false)
                                debugPrint(response.result.error as Any)
                            }
        }
    }

    func loginUser(email: String,
                   password: String,
                   completion: @escaping CompletionHandler) {

        let body = Constants.Body.register_user(email: email, password: password)

        Alamofire.request(Constants.URL.login,
                          method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: Constants.Header.registerUser).responseJSON { response in

                            if response.result.error == nil {
                                guard let data = response.data else { return }
                                let json = JSON(data: data)
                                self.userEmail = json["user"].stringValue
                                self.authToken = json["token"].stringValue

                                self.isLoggedIn = true
                                completion(true)
                            } else {
                                completion(false)
                                debugPrint(response.result.error as Any)
                            }
        }
    }

    func setupUser(name: String,
                   email: String,
                   color: String,
                   avatarName: String,
                   completion: @escaping CompletionHandler) {

        let body = Constants.Body.setup_user(name: name,
                                             email: email,
                                             avatarName: avatarName,
                                             color: color)

        Alamofire.request(Constants.URL.userAdd,
                          method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: Constants.Header.setupUser).responseJSON { response in

                            if response.result.error == nil {
                                guard let data = response.data else { return }
                                let json = JSON(data: data)
                                let color = json["avatarColor"].stringValue
                                let avatarName = json["avatarName"].stringValue
                                let email = json["email"].stringValue
                                let name = json["name"].stringValue
                                let id = json["_id"].stringValue

                                UserDataService.instance.setUserData(color: color,
                                                                     avatarName: avatarName,
                                                                     email: email,
                                                                     name: name,
                                                                     id: id)
                                completion(true)
                            } else {
                                completion(false)
                                debugPrint(response.result.error as Any)
                            }
        }
    }
}
