//
//  AddChannelViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var descriptionTextField: UITextField!
    @IBOutlet private var backgroundView: UIView!

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.addGestures()
    }

    // MARK: Actions

    @IBAction private func closeModalTapped(_ sender: Any) {
        self.dismissView()
    }

    @IBAction private func createChannelTapped(_ sender: Any) {
        guard let channelName = nameTextField.text,
            channelName != "",
            let channelDescription = descriptionTextField.text else { return }

        SocketService.shared.addChannel(channelName: channelName, channelDescription: channelDescription) { success in
            if success {
                self.dismissView()
            }
        }
    }

    // MARK: Private Functions

    private func setupView() {
        self.nameTextField.delegate = self
        self.descriptionTextField.delegate = self

        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.placeholder]
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: attributes)
        self.descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: attributes)
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    private func addGestures() {
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        let swipeDownToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissView))
        swipeDownToDismiss.direction = UISwipeGestureRecognizer.Direction.down
        self.backgroundView.addGestureRecognizer(tapToDismiss)
        self.backgroundView.addGestureRecognizer(swipeDownToDismiss)
    }
}

extension AddChannelViewController: UITextFieldDelegate {

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.createChannelTapped(self)
        return true
    }

}
