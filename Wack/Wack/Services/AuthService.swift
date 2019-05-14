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
            return self.defaults.bool(forKey: Constants.UserDefaults.logged_in_key)
        }
        set {
            self.defaults.set(newValue, forKey: Constants.UserDefaults.logged_in_key)
        }
    }
    
    var authToken: String {
        get {
            return self.defaults.value(forKey: Constants.UserDefaults.token_key) as! String
        }
        set {
            self.defaults.set(newValue, forKey: Constants.UserDefaults.token_key)
        }
    }
    
    var userEmail: String {
        get {
            return self.defaults.value(forKey: Constants.UserDefaults.user_email) as! String
        }
        set {
            self.defaults.set(newValue, forKey: Constants.UserDefaults.user_email)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let body = Constants.URL.body(email: email.lowercased(), password: password)
        
        Alamofire.request(Constants.URL.url_register,
                          method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: Constants.URL.header).responseString { response in
                            if response.result.error == nil {
                                completion(true)
                            } else {
                                completion(false)
                                debugPrint(response.result.error as Any)
                            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {

        let body = Constants.URL.body(email: email.lowercased(), password: password)

        Alamofire.request(Constants.URL.url_login,
                          method: .post,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: Constants.URL.header).responseJSON { response in
                            if response.result.error == nil {
                                // Regular way to parse. lets try swiftyJSON next
//                                guard let json = response.result.value as? [String: Any],
//                                    let email = json["user"] as? String,
//                                    let token = json["token"] as? String else { return }
//                                self.userEmail = email
//                                self.authToken = token

                                // SwiftyJSON
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
}
