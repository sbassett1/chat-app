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

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    // MARK: Actions

    @IBAction private func closeModalTapped(_ sender: Any) {
        self.dismissView()
    }

    @IBAction func createChannelTapped(_ sender: Any) {
        self.dismissView()
    }

    // MARK: Private Functions

    private func setupView() {
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        let swipeDownToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissView))
        swipeDownToDismiss.direction = UISwipeGestureRecognizer.Direction.down
        self.backgroundView.addGestureRecognizer(tapToDismiss)
        self.backgroundView.addGestureRecognizer(swipeDownToDismiss)

        let attributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.placeholder]
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: attributes)
        self.descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: attributes)
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
