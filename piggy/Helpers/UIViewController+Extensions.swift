//
//  UIViewController+Extensions.swift
//  piggy
//
//  Created by Dason Tiovino on 20/08/24.
//

import Foundation
import UIKit

extension UIViewController {

    /// Returns the nib name based on the class name.
    public static func nibName() -> String {
        return String(describing: self) + "XIB"
    }
}
