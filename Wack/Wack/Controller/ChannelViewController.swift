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

    // MARK: Variables

    let userData = UserDataService.shared
    let userAuth = AuthService.shared
    let commData = MessageService.shared

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.channelTableView.delegate = self
        self.channelTableView.dataSource = self

        self.setupView()
        self.registerNotifications()

        SocketService.shared.getChannel { success in
            if success {
                self.channelTableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupUserInfo()
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

    @IBAction func addChannelButtonTapped(_ sender: Any) {
        let addChannel = AddChannelViewController()
        addChannel.modalPresentationStyle = .custom
        present(addChannel, animated: true, completion: nil)
    }

    @IBAction private func prepareForUnwind(segue: UIStoryboardSegue) { }

    // MARK: Private Functions

    private func setupView() {
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.userDataChanged(_:)),
                                               name: Constants.Notifications.userDataChanged,
                                               object: nil)
    }

    @objc private func userDataChanged(_ notification: Notification) {
        self.setupUserInfo()
    }

    private func setupUserInfo() {
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

}
