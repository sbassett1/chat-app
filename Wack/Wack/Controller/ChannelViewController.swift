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
    
    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.userDataChanged(_:)),
                                               name: Constants.Notifications.user_data_changed,
                                               object: nil)
    }

    // MARK: Actions

    @IBAction private func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.to_login, sender: nil)
    }

    @IBAction private func prepareForUnwind(segue: UIStoryboardSegue) { }

    // MARK: Private Functions

    @objc private func userDataChanged(_ notification: Notification) {
        if AuthService.instance.isLoggedIn {
            self.loginButton.setTitle(UserDataService.instance.name, for: .normal)
            self.userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            self.userImageView.backgroundColor = UserDataService.instance.color.asUIColor
        } else {
            self.loginButton.setTitle("Login", for: .normal)
            self.userImageView.image = UIImage(named: "menuProfileIcon")
            self.userImageView.backgroundColor = UIColor.clear
        }
    }
}
