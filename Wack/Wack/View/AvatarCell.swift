//
//  AvatarCell.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {

    // MARK: Outlets

    @IBOutlet private var avatarImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupView()
    }

    // MARK: Global Functions

    func configureCell(index: Int, type: AvatarType) {
        let name = type == AvatarType.dark ? ("dark", UIColor.lightGray.cgColor) : ("light", UIColor.gray.cgColor)
        self.avatarImage.image = UIImage(named: "\(name.0)\(index)")
        self.layer.backgroundColor = name.1
    }

    // MARK: Private Functions

    private func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
