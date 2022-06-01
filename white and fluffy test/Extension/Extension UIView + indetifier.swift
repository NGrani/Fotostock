//
//  Extension UIView + indetifier.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
