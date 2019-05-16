//
//  RoundedView.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

@IBDesignable
class RoundedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }

    func setupView() {
        self.layer.cornerRadius = self.cornerRadius
    }
}
