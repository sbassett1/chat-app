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
    @IBOutlet private var typingUsersLabel: UILabel!
    @IBOutlet private var chatTableBottomConstraint: NSLayoutConstraint!

    // MARK: Variables

    var isTyping = false
    let auth = AuthService.shared
    let user = UserDataService.shared
    let comms = MessageService.shared
    let socket = SocketService.shared

    var isLoggedIn: Bool {
        return self.auth.isLoggedIn
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
                                        self.sendMessageButton.isHidden = true
                                        self.socket.socket.emit(Constants.Socket.stop, self.user.name, channelId)
                                    }
            }
        }
    }

    @IBAction func messageTextFieldEditing(_ sender: Any) {
        guard let channelId = self.comms.selectedChannel?._id else { return }
        let typing = !(self.messageTextField.text?.isEmpty ?? false)
        let event = typing ? Constants.Socket.start : Constants.Socket.stop
        self.sendMessageButton.isHidden = !typing
        self.socket.socket.emit(event, self.user.name, channelId)
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
            self.channelNameLabel.text = Constants.Labels.wack
        } else {
            self.channelNameLabel.text = Constants.Labels.signIn
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
                    self.channelNameLabel.text = Constants.Labels.noChannels
                }
            }
        }
    }

    private func getMessages() {
        guard let channelId = self.comms.selectedChannel?._id else { return }
        self.comms.findAllMessagesForChannel(channelId: channelId) { success in
            if success {
                self.chatTableView.reloadData()
                self.adjustTableBottom()
            }
        }
    }

    private func registerNotifications() {

        let notification = NotificationCenter.default

        if self.isLoggedIn {
            self.auth.findUserByEmail { _ in
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

    private func adjustTableBottom() {
        let lastIndex = IndexPath(row: self.comms.messages.count - 1, section: 0)
        self.chatTableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
    }

    private func socketGetMessage() {
        self.socket.getChatMessage { newMessage in
            if newMessage.channelId == self.comms.selectedChannel?._id && self.isLoggedIn {
                self.comms.messages.append(newMessage)
                self.chatTableView.reloadData()
                if !self.comms.messages.isEmpty {
                    self.adjustTableBottom()
                }
            }
        }

        self.socket.getTypingUsers { typingUsers in
            guard let channelId = self.comms.selectedChannel?._id else { return }
            var names = ""
            var numberOfUsersTyping = 0

            for (typingUser, channel) in typingUsers {
                if typingUser != self.user.name && channel == channelId {
                    if names.isEmpty {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfUsersTyping += 1
                }
            }

            if numberOfUsersTyping > 0 && self.isLoggedIn {
                var verb = "is"
                if numberOfUsersTyping > 1 {
                    verb = "are"
                }
                self.typingUsersLabel.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLabel.text = ""
            }
            self.typingUsersLabel.backgroundColor = names.isEmpty ? UIColor.clear : UIColor.white
            self.chatTableBottomConstraint.constant = names.isEmpty ? 0 : 30
            if !(self.messageTextField.text?.isEmpty ?? true) && names.isEmpty {
                self.adjustTableBottom()
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
        if !(self.messageTextField.text?.isEmpty ?? true) {
            self.sendMessageButtonTapped(self)
            return true
        } else {
            return false
        }
    }

}
