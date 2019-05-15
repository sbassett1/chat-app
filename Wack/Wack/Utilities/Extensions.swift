//
//  Extensions.swift
//  Wack
//
//  Created by Stephen Bassett on 5/15/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

extension UIColor {

    var asString: String {
        guard let components = self.cgColor.components else { return "" }
        return "[\(components[0]), \(components[1]), \(components[2]), \(components[3])]"
    }

}

extension String {

    var asUIColor: UIColor {
        let componentsString = self.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        let components = componentsString.components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                       green: CGFloat((components[1] as NSString).floatValue),
                       blue: CGFloat((components[2] as NSString).floatValue),
                       alpha: CGFloat((components[3] as NSString).floatValue))
    }

}
