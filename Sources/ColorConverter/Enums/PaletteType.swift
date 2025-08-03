//
//  PaletteType.swift
//  ColorConverter
//
//  Created by David Sherlock on 03/08/2025.
//


/// Types of color palettes that can be generated
public enum PaletteType: String, CaseIterable, Sendable {
    case complementary = "complementary"
    case triadic = "triadic"
    case monochromatic = "monochromatic"
    
    /// Human-readable description
    public var description: String {
        switch self {
        case .complementary: return "Complementary (opposite colors)"
        case .triadic: return "Triadic (three evenly spaced colors)"
        case .monochromatic: return "Monochromatic (variations of one hue)"
        }
    }
    
    /// Typical number of colors in this palette type
    public var colorCount: Int {
        switch self {
        case .complementary: return 2
        case .triadic: return 3
        case .monochromatic: return 5
        }
    }
}