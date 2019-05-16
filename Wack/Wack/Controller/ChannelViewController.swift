//
//  ChannelViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/13/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var userImageView: CircleImage!

    // MARK: Variables

    let userData = UserDataService.instance
    let userAuth = AuthService.instance

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.userDataChanged(_:)),
                                               name: Constants.Notifications.userDataChanged,
                                               object: nil)
    }

    // MARK: Actions

    @IBAction private func loginButtonTapped(_ sender: Any) {
        if self.userAuth.isLoggedIn {
            let profileView = ProfileViewController()
            profileView.modalPresentationStyle = .custom
            present(profileView, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: Constants.Segues.toLogin, sender: nil)
        }
    }

    @IBAction private func prepareForUnwind(segue: UIStoryboardSegue) { }

    // MARK: Private Functions

    @objc private func userDataChanged(_ notification: Notification) {
        if self.userAuth.isLoggedIn {
            self.loginButton.setTitle(self.userData.name, for: .normal)
            self.userImageView.image = UIImage(named: self.userData.avatarName)
            self.userImageView.backgroundColor = self.userData.color.asUIColor
        } else {
            self.loginButton.setTitle("Login", for: .normal)
            self.userImageView.image = #imageLiteral(resourceName: "menuProfileIcon")
            self.userImageView.backgroundColor = UIColor.clear
        }
    }
}
