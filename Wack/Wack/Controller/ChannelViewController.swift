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

    // MARK: App Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
    }

    // MARK: Actions

    @IBAction private func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }

    @IBAction private func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

}
