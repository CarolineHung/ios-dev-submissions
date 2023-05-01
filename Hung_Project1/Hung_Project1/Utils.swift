//
//  Utils.swift
//  Hung_Project1
//
//  Created by student on 4/25/23.
//

import Foundation
import UIKit

extension UIColor {
    static func parseHex(hex: String) -> UIColor? {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if !hexString.hasPrefix("#") { return nil }
        hexString.remove(at: hex.startIndex)
        
        if hexString.count != 6 { return nil }

        var hexNumber: UInt64 = 0
        
        if !Scanner(string: hexString).scanHexInt64(&hexNumber) { return nil }

        return UIColor(
            red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexNumber & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
