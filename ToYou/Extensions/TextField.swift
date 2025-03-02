//
//  TextField.swift
//  ToYou
//
//  Created by 이승준 on 2/26/25.
//

import UIKit

extension UITextField {
    
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color
            ]
        )
    }
    
}
