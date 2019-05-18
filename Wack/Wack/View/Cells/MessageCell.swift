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

        // ISO-8601 format date: 2019-05-17T21:49:25.590Z
        guard var isoDate = message.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)

        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))

        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"

        guard let finalDate = chatDate else { return }
        let date = newFormatter.string(from: finalDate)
        self.timeStampLabel.text = date
    }
}
