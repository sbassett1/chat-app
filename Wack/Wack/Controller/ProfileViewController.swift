//
//  ProfileViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var backgroundView: UIView!

    // MARK: Variables

    let user = UserDataService.shared

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    // MARK: Actions

    @IBAction private func closeProfileTapped(_ sender: Any) {
        self.dismissView()
    }

    @IBAction private func logoutTapped(_ sender: Any) {
        self.user.logoutUser()
        NotificationCenter.default.post(name: Constants.Notifications.userDataChanged, object: nil)
        self.dismissView()
    }

    // MARK: Private Functions

    private func setupView() {
        self.profileImageView.image = UIImage(named: self.user.avatar)
        self.profileImageView.backgroundColor = self.user.color.asUIColor
        self.usernameLabel.text = self.user.name
        self.emailLabel.text = self.user.email

        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        let swipeDownToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissView))
        swipeDownToDismiss.direction = UISwipeGestureRecognizer.Direction.down
        self.backgroundView.addGestureRecognizer(tapToDismiss)
        self.backgroundView.addGestureRecognizer(swipeDownToDismiss)
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
