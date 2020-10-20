//
//  UIView+Extension.swift
//  IPTracker
//
//  Created by Jordan Christensen on 10/19/20.
//

import UIKit

// credit to Stéphane de Luca @ https://stackoverflow.com/questions/10167266
extension UIView {
    func round(corners: UIRectCorner, with radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
