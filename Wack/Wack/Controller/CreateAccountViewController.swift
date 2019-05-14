//
//  CreateAccountViewController.swift
//  Wack
//
//  Created by Stephen Bassett on 5/14/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: Actions

    @IBAction private func closeTapped(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    

}
