//
//  UITableViewCell+Extensions.swift
//  piggy
//
//  Created by Dason Tiovino on 20/08/24.
//

import Foundation
import UIKit

extension UITableViewCell {

    /// Returns the cell identifier based on the class name.
    public static var cellIdentifier: String {
        return String(describing: self)
    }

    /// Returns the nib name based on the class name.
    public static func nibName() -> String {
        return cellIdentifier + "XIB"
    }
}
