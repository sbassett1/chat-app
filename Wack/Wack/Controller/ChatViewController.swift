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
    @IBOutlet private var messageTextField: UITextField!

    // MARK: Variables

    let user = AuthService.shared
    let comms = MessageService.shared

    var isLoggedIn: Bool {
        return self.user.isLoggedIn
    }

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestures()
        self.registerNotifications()
        self.view.bindToKeyboard()
    }

    // MARK: Actions

    @IBAction private func sendMessageButtonTapped(_ sender: Any) {
        if self.isLoggedIn {
            guard let channelId = self.comms.selectedChannel?._id,
                let message = self.messageTextField.text else { return }
            SocketService.shared.addMessage(messageBody: message,
                                            userId: UserDataService.shared.id,
                                            channelId: channelId) { success in
                                                if success {
                                                    self.messageTextField.text = ""
                                                    self.messageTextField.resignFirstResponder()
                                                }
            }
        }
    }

    // MARK: Private Functions

    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        // SWReveal Gestures
        guard let revealVC = self.revealViewController(),
            let panGesture = revealVC.panGestureRecognizer(),
            let tapGesture = revealVC.tapGestureRecognizer() else { return }
        self.menuButton.addTarget(revealVC, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(tap)
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

    @objc private func handleTap() {
        self.view.endEditing(true)
    }

    private func updateWithChannel() {
        let channelName = self.comms.selectedChannel?.name ?? ""
        channelNameLabel.text = "#\(channelName)"
        self.getMessages()
    }

    private func onLoginGetMessages() {
        self.comms.findAllChannels { success in
            if success {
                if !self.comms.channels.isEmpty {
                    self.comms.selectedChannel = self.comms.channels.first
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No Channels Joined"
                }
            }
        }
    }

    private func getMessages() {
        guard let channelId = self.comms.selectedChannel?._id else { return }
        self.comms.findAllMessagesForChannel(channelId: channelId) { success in
            if success {

            }
        }
    }

    private func registerNotifications() {

        let notification = NotificationCenter.default

        if self.isLoggedIn {
            self.user.findUserByEmail { _ in
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
