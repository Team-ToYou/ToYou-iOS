//
//  UIImage.swift
//  ToYou
//
//  Created by 김미주 on 01/03/2025.
//

import UIKit

extension UIImage {
    // segmentedControl 배경용
    static func colorImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 20)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
