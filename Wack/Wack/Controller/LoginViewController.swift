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

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.to_create_account, sender: nil)
    }
}
