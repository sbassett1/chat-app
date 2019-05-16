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
    @IBOutlet private var channelTableView: UITableView!
    @IBOutlet private var addChannelButton: UIButton!
    @IBOutlet private var channelsLabel: UILabel!

    // MARK: Variables

    let userData = UserDataService.shared
    let userAuth = AuthService.shared
    let commData = MessageService.shared

    var isLoggedIn: Bool {
        return self.userAuth.isLoggedIn
    }

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.registerNotifications()
        self.socketGetChannel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupUserInfo()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.addChannelButton.isHidden = !self.isLoggedIn
        self.channelsLabel.text = !self.isLoggedIn ? "Sign in to add and join channels" : "CHANNELS"
    }

    // MARK: Actions

    @IBAction private func loginButtonTapped(_ sender: Any) {
        if self.isLoggedIn {
            let profileView = ProfileViewController()
            profileView.modalPresentationStyle = .custom
            present(profileView, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: Constants.Segues.toLogin, sender: nil)
        }
    }

    @IBAction private func addChannelButtonTapped(_ sender: Any) {
        // Instead of hiding button could popup alert
        // Saying to login in to add channel
        let addChannel = AddChannelViewController()
        addChannel.modalPresentationStyle = .custom
        present(addChannel, animated: true, completion: nil)
    }

    @IBAction private func prepareForUnwind(segue: UIStoryboardSegue) { }

    // MARK: Private Functions

    private func setupView() {
        self.channelTableView.delegate = self
        self.channelTableView.dataSource = self

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.userDataChanged),
                                               name: Constants.Notifications.userDataChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.channelsLoaded),
                                               name: Constants.Notifications.channelsLoaded,
                                               object: nil)
    }

    @objc private func userDataChanged() {
        self.setupUserInfo()
    }

    @objc private func channelsLoaded() {
        self.channelTableView.reloadData()
    }

    private func setupUserInfo() {
        if self.isLoggedIn {
            self.loginButton.setTitle(self.userData.name, for: .normal)
            self.userImageView.image = UIImage(named: self.userData.avatarName)
            self.userImageView.backgroundColor = self.userData.color.asUIColor
        } else {
            self.loginButton.setTitle("Login", for: .normal)
            self.userImageView.image = #imageLiteral(resourceName: "menuProfileIcon")
            self.userImageView.backgroundColor = UIColor.clear
            self.channelTableView.reloadData()
        }
    }

    private func socketGetChannel() {
        SocketService.shared.getChannel { success in
            if success {
                self.channelTableView.reloadData()
            }
        }
    }

}

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commData.channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.channelTableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifiers.channelCell, for: indexPath) as? ChannelCell else { return UITableViewCell() }
        let channel = self.commData.channels[indexPath.row]
        cell.configureCell(channel: channel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = self.commData.channels[indexPath.row]
        self.commData.selectedChannel = channel
        NotificationCenter.default.post(name: Constants.Notifications.channelSelected, object: nil)
        self.revealViewController()?.revealToggle(animated: true)
    }
}
