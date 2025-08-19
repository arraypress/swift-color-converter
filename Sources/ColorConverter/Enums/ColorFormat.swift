//
//  ColorFormat.swift
//  ColorConverter
//
//  Created by David Sherlock on 03/08/2025.
//

import Foundation

/// Supported color formats for conversion
public enum ColorFormat: String, CaseIterable, Sendable {
    case hex = "hex"
    case rgb = "rgb"
    case hsl = "hsl"
    
    /// Human-readable description
    public var description: String {
        switch self {
        case .hex: return "Hexadecimal (#FF5733)"
        case .rgb: return "RGB (rgb(255,87,51))"
        case .hsl: return "HSL (hsl(11,100%,60%))"
        }
    }
    
    /// Example color in this format
    public var example: String {
        switch self {
        case .hex: return "#FF5733"
        case .rgb: return "rgb(255,87,51)"
        case .hsl: return "hsl(11,100%,60%)"
        }
    }
    
    /// Whether this format supports alpha/transparency
    public var supportsAlpha: Bool {
        return [.rgb, .hsl].contains(self)
    }
}
