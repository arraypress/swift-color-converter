//
//  RGBColor.swift
//  ColorConverter
//
//  Created by David Sherlock on 03/08/2025.
//

import Foundation

/// RGB color components
public struct RGBColor: Sendable, Equatable {
    public let red: Int      // 0-255
    public let green: Int    // 0-255
    public let blue: Int     // 0-255
    public let alpha: Double // 0.0-1.0
    
    public init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.red = max(0, min(255, red))
        self.green = max(0, min(255, green))
        self.blue = max(0, min(255, blue))
        self.alpha = max(0.0, min(1.0, alpha))
    }
}
