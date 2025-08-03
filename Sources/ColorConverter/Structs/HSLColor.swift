//
//  HSLColor.swift
//  ColorConverter
//
//  Created by David Sherlock on 03/08/2025.
//

import Foundation

/// HSL color components
public struct HSLColor: Sendable, Equatable {
    public let hue: Double         // 0-360
    public let saturation: Double  // 0-100
    public let lightness: Double   // 0-100
    public let alpha: Double       // 0.0-1.0
    
    public init(hue: Double, saturation: Double, lightness: Double, alpha: Double = 1.0) {
        self.hue = hue.truncatingRemainder(dividingBy: 360)
        self.saturation = max(0, min(100, saturation))
        self.lightness = max(0, min(100, lightness))
        self.alpha = max(0.0, min(1.0, alpha))
    }
}
