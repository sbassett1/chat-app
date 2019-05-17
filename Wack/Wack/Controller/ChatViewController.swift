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
    @IBOutlet private var chatTableView: UITableView!
    @IBOutlet private var sendMessageButton: UIButton!

    // MARK: Variables

    var isTyping = false
    let user = AuthService.shared
    let comms = MessageService.shared
    let socket = SocketService.shared

    var isLoggedIn: Bool {
        return self.user.isLoggedIn
    }

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.messageTextField.delegate = self

        self.chatTableView.estimatedRowHeight = 80
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.sendMessageButton.isHidden = true

        self.addGestures()
        self.registerNotifications()
        self.view.bindToKeyboard()

        self.socketGetMessage()
    }

    // MARK: Actions

    @IBAction private func sendMessageButtonTapped(_ sender: Any) {
        if self.isLoggedIn {
            guard let channelId = self.comms.selectedChannel?._id,
                let message = self.messageTextField.text else { return }
            self.socket.addMessage(messageBody: message,
                                   userId: UserDataService.shared.id,
                                   channelId: channelId) { success in
                                    if success {
                                        self.messageTextField.text = ""
//                                        self.messageTextField.resignFirstResponder()
                                    }
            }
        }
    }

    @IBAction func messageTextFieldEditing(_ sender: Any) {
        self.sendMessageButton.isHidden = self.messageTextField.text?.isEmpty ?? true
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
            self.chatTableView.reloadData()
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
                self.chatTableView.reloadData()
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

    private func socketGetMessage() {
        self.socket.getChatMessage { success in
            if success {
                self.chatTableView.reloadData()
                if !self.comms.messages.isEmpty {
                    let lastIndex = IndexPath(row: self.comms.messages.count - 1, section: 0)
                    self.chatTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
                }
            }
        }
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comms.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifiers.messageCell,
                                                       for: indexPath) as? MessageCell else { return UITableViewCell() }
        let message = self.comms.messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }

}

extension ChatViewController: UITextFieldDelegate {

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessageButtonTapped(self)
        return true
    }

}
