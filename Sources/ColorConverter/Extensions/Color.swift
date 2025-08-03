//
//  Color.swift
//  ColorConverter
//
//  Created by David Sherlock on 03/08/2025.
//

import Foundation

// MARK: - RGB Color Extensions

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

// MARK: - HSL Color Extensions

extension HSLColor {
    
    /// Convert HSL to RGB color space
    func toRGB() -> RGBColor {
        let h = hue / 360.0
        let s = saturation / 100.0
        let l = lightness / 100.0
        
        if s == 0 {
            // Achromatic (grayscale)
            let value = Int((l * 255).rounded())
            return RGBColor(red: value, green: value, blue: value, alpha: alpha)
        }
        
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        
        let r = hueToRGB(p: p, q: q, t: h + 1.0/3.0)
        let g = hueToRGB(p: p, q: q, t: h)
        let b = hueToRGB(p: p, q: q, t: h - 1.0/3.0)
        
        return RGBColor(
            red: Int((r * 255).rounded()),
            green: Int((g * 255).rounded()),
            blue: Int((b * 255).rounded()),
            alpha: alpha
        )
    }
    
    private func hueToRGB(p: Double, q: Double, t: Double) -> Double {
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }
        if t < 1.0/6.0 { return p + (q - p) * 6 * t }
        if t < 1.0/2.0 { return q }
        if t < 2.0/3.0 { return p + (q - p) * (2.0/3.0 - t) * 6 }
        return p
    }
    
}
