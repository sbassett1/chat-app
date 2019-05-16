//
//  LoginViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loadingSpinner: UIActivityIndicatorView!

    // MARK: Variables

    let userAuth = AuthService.shared

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    // MARK: Actions

    @IBAction private func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func createAccountButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.toCreateAccount, sender: nil)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        self.loadingSpinner.isHidden = false
        self.loadingSpinner.startAnimating()

        guard let email = self.emailTextField.text,
            email != "",
            let password = self.passwordTextField.text,
            password != "" else { return } // alert user to enter text

        self.userAuth.loginUser(email: email, password: password) { success in
            if success {
                self.userAuth.findUserByEmail { success in
                    if success {
                        NotificationCenter.default.post(name: Constants.Notifications.userDataChanged, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            // Alert for failure and try again
            self.loadingSpinner.isHidden = true
            self.loadingSpinner.stopAnimating()
        }
    }

    // MARK: Private Functions

    private func setupView() {
        self.loadingSpinner.isHidden = true

        let tapOffKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOffKeyboard))
        self.view.addGestureRecognizer(tapOffKeyboard)

        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.placeholder]
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: attributes)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
    }

    @objc private func handleTapOffKeyboard() {
        self.view.endEditing(true)
    }
}
