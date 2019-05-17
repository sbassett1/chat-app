//
//  CreateAccountViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var userImage: UIImageView!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var loadingSpinner: UIActivityIndicatorView!

    // MARK: Variables

    var avatarName = "profileDefault"
    var color = "[0.5, 0.5, 0.5, 1]"
    var backgroundColor: UIColor?
    let user = UserDataService.shared
    let auth = AuthService.shared

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.user.avatarName != "" {
            self.avatarName = self.user.avatarName
            self.userImage.image = UIImage(named: self.avatarName)
            if self.avatarName.contains("light") && self.backgroundColor == nil {
                self.userImage.backgroundColor = UIColor.lightGray
            }
        }
    }

    // MARK: Actions

    @IBAction private func closeTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.unwindToChannel, sender: nil)
    }

    @IBAction private func createAccountButtonTapped(_ sender: Any) {

        // Add alert to suggest changing the avatar and color

        self.loadingSpinner.isHidden = false
        self.loadingSpinner.startAnimating()

        guard let username = self.usernameTextField.text, username != "" else { return }
        guard let email = self.emailTextField.text, email != "" else { return }
        guard let password = self.passwordTextField.text, password != "" else { return }

        self.auth.registerUser(email: email, password: password) { success in
            if success {
                print("registration was successfull!!!!!")
                self.auth.loginUser(email: email, password: password) { success in
                    if success {
                        self.auth.setupUser(name: username,
                                            email: email,
                                            color: self.color,
                                            avatarName: self.avatarName) { success in
                                                if success {
                                                    self.loadingSpinner.isHidden = true
                                                    self.loadingSpinner.stopAnimating()
                                                    self.performSegue(withIdentifier: Constants.Segues.unwindToChannel, sender: nil)
                                                    NotificationCenter.default.post(name: Constants.Notifications.userDataChanged, object: nil)
                                                }
                        }
                    }
                }
            }
        }
    }

    @IBAction private func pickAvatarButtonTapped(_ sender: Any) {
        self.segueToAvatarPicker()
    }

    @IBAction private func pickBackgroundColorButtonTapped(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255)) / 255
        let green = CGFloat(arc4random_uniform(255)) / 255
        let blue = CGFloat(arc4random_uniform(255)) / 255
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)

        self.backgroundColor = color
        self.color = color.asString
        UIView.animate(withDuration: 0.2) {
            self.userImage.backgroundColor = self.backgroundColor
        }
    }

    // MARK: Private Functions

    private func setupView() {
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

        self.loadingSpinner.isHidden = true

        let tapOffKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOffKeyboard))
        self.view.addGestureRecognizer(tapOffKeyboard)

        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.segueToAvatarPicker))
        self.avatarImageView.addGestureRecognizer(tapImageGesture)
        self.avatarImageView.isUserInteractionEnabled = true

        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.placeholder]
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: attributes)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: attributes)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
    }

    @objc private func segueToAvatarPicker() {
        performSegue(withIdentifier: Constants.Segues.toAvatarPicker, sender: nil)
    }

    @objc private func handleTapOffKeyboard() {
        self.view.endEditing(true)
    }
}

extension CreateAccountViewController: UITextFieldDelegate {

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.createAccountButtonTapped(self)
        return true
    }

}
