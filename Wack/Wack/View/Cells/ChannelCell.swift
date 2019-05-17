//
//  ChannelCell.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

class ChannelCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet private var channelLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.layer.backgroundColor = selected ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.2) : UIColor.clear.cgColor // #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
    }

    // MARK: Global Functions

    func configureCell(channel: Channel) {
        let name = channel.name
        self.channelLabel.text = "#\(name)"
        self.channelLabel.font = UIFont(name: Constants.Fonts.regular, size: 17)

        for id in MessageService.shared.unreadChannels where id == channel._id {
            self.channelLabel.font = UIFont(name: Constants.Fonts.bold, size: 22)
        }
    }

}
