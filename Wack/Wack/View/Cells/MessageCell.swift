//
//  MessageCell.swift
//  Wack
//
//  Created by Stephen Bassett on 5/17/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet private var userImageView: CircleImage!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var timeStampLabel: UILabel!
    @IBOutlet private var messageBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Global Functions

    func configureCell(message: Message) {
        self.messageBodyLabel.text = message.messageBody
        self.userNameLabel.text = message.userName
        self.userImageView.image = UIImage(named: message.userAvatar)
        self.userImageView.backgroundColor = message.userAvatarColor.asUIColor
        self.backgroundColor = message.userAvatarColor.asTransparentUIColor
    }
}
