//
//  Extensions.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements

extension UITextField {
    func setUnderLine() {
        borderStyle = .none
        let underline = UIView()
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        underline.backgroundColor = .white
        addSubview(underline)
        bringSubviewToFront(underline)
    }
}


extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[0-9]", options: .regularExpression) == nil
    }
}
