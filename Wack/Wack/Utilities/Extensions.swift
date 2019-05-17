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
        guard self != "" else { return UIColor.clear }
        let componentsString = self.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        let components = componentsString.components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                       green: CGFloat((components[1] as NSString).floatValue),
                       blue: CGFloat((components[2] as NSString).floatValue),
                       alpha: CGFloat((components[3] as NSString).floatValue))
    }

}

extension UIView {

    // Have to check for iphoneX dimensions as the textField does not bind to keyboard
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIView.keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    @objc func keyboardWillChange(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y

        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: { _ in
            self.layoutIfNeeded()
        })
    }
}

extension UIApplication {

    static var isDeviceWithSafeArea: Bool {
        if #available(iOS 11.0, *) {
            if let topPadding = shared.keyWindow?.safeAreaInsets.bottom,
                topPadding > 0 {
                return true
            }
        }
        return false
    }

}
