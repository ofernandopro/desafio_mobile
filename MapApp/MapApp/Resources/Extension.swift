//
//  Extension.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import MapKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension CLLocation {
    /// Provide optional coordinate components labels
    func locationString() -> String {
        return "\(latitudeString()),\(longitudeString())"
    }

    // Get string for each component
    //This is not necessary, as you could combine this into formattedLabel: label
    //But it's good to have these separate in case you need just one of the components
    func latitudeString() -> String {
        return "\(self.coordinate.latitude)"
    }

    func longitudeString() -> String {
        return "\(self.coordinate.longitude)"
    }

}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
