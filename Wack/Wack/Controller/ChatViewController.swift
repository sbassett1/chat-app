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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }
    
}
