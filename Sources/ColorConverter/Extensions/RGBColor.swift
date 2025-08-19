//
//  RGBColor.swift
//  ColorConverter
//
//  Created by David Sherlock on 19/08/2025.
//

import Foundation

extension RGBColor {
    
    /// Convert RGB to HSL color space
    func toHSL() -> HSLColor {
        let r = Double(red) / 255.0
        let g = Double(green) / 255.0
        let b = Double(blue) / 255.0
        
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let delta = max - min
        
        // Lightness
        let lightness = (max + min) / 2.0
        
        // Saturation
        let saturation: Double
        if delta == 0 {
            saturation = 0
        } else {
            saturation = lightness > 0.5 ? delta / (2.0 - max - min) : delta / (max + min)
        }
        
        // Hue
        let hue: Double
        if delta == 0 {
            hue = 0
        } else if max == r {
            hue = ((g - b) / delta + (g < b ? 6 : 0)) / 6
        } else if max == g {
            hue = ((b - r) / delta + 2) / 6
        } else {
            hue = ((r - g) / delta + 4) / 6
        }
        
        return HSLColor(
            hue: (hue * 360).rounded(),
            saturation: (saturation * 100).rounded(),
            lightness: (lightness * 100).rounded(),
            alpha: alpha
        )
    }
    
}
