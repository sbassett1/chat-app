//
//  ChatViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/13/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var menuButton: UIButton!
    @IBOutlet private var channelNameLabel: UILabel!

    // MARK: Variables

    let userAuth = AuthService.shared
    let commData = MessageService.shared

    var isLoggedIn: Bool {
        return self.userAuth.isLoggedIn
    }

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestures()
        self.registerNotifications()
    }

    // MARK: Private Functions

    private func addGestures() {
        guard let revealVC = self.revealViewController(),
            let panGesture = revealVC.panGestureRecognizer(),
            let tapGesture = revealVC.tapGestureRecognizer() else { return }
        self.menuButton.addTarget(revealVC, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc private func userDataDidChange() {
        if self.isLoggedIn {
            self.onLoginGetMessages()
            self.channelNameLabel.text = "Wack"
        } else {
            self.channelNameLabel.text = "Please Log In"
        }
    }

    @objc private func channelSelected() {
        self.updateWithChannel()
    }

    private func updateWithChannel() {
        let channelName = self.commData.selectedChannel?.name ?? ""
        channelNameLabel.text = "#\(channelName)"
    }

    private func onLoginGetMessages() {
        self.commData.findAllChannels { success in
            if success {
                // Do stuff with channels
            }
        }
    }

    private func registerNotifications() {

        let notification = NotificationCenter.default

        if self.isLoggedIn {
            self.userAuth.findUserByEmail { _ in
                notification.post(name: Constants.Notifications.userDataChanged, object: nil)
            }
        }
        notification.addObserver(self,
                                 selector: #selector(self.userDataDidChange),
                                 name: Constants.Notifications.userDataChanged,
                                 object: nil)
        notification.addObserver(self,
                                 selector: #selector(self.channelSelected),
                                 name: Constants.Notifications.channelSelected,
                                 object: nil)
    }

}
