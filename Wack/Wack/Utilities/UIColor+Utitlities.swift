//
//  UIColor+Utitlities.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

public extension UIColor {

    var asString: String {
        guard let components = self.cgColor.components else { return "" }
        return "[\(components[0]), \(components[1]), \(components[2]), \(components[3])]"
    }

}
