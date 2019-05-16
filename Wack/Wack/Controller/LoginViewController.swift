//
//  LoginViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions

    @IBAction private func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func createAccountButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.toCreateAccount, sender: nil)
    }
}
