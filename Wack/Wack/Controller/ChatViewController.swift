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

    // MARK: App LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuSetup()
    }

    // MARK: Private Functions

    private func menuSetup() {
        guard let revealVC = self.revealViewController(),
            let panGesture = revealVC.panGestureRecognizer(),
            let tapGesture = revealVC.tapGestureRecognizer() else { return }
        self.menuButton.addTarget(revealVC, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
    }

}
