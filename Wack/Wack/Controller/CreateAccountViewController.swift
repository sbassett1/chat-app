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

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userImage: UIImageView!

    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: Actions

    @IBAction private func closeTapped(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = self.emailTextField.text, email != "" else { return }
        guard let password = self.passwordTextField.text, password != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: password) { success in
            if success {
                print("registration was successful!!!!!")
            }
        }
    }

    @IBAction func pickAvatarButtonTapped(_ sender: Any) {
    }

    @IBAction func pickBackgroundColorButtonTapped(_ sender: Any) {
    }

}
