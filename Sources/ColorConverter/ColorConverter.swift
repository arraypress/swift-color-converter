//
//  ColorConverter.swift
//  ColorConverter
//
//  A focused color converter for everyday design and development needs
//  Created on 03/08/2025.
//

import Foundation

/// A simple, focused color converter for the most common design workflows.
///
/// Converts between HEX, RGB, and HSL color formats, generates harmonious color palettes,
/// and checks accessibility contrast ratios. Perfect for Shortcuts integration.
///
/// ## Example Usage
///
/// ```swift
/// // Convert colors
/// let rgb = ColorConverter.convert("#FF5733", to: .rgb)
/// // Result: "rgb(255,87,51)"
///
/// // Generate palettes
/// let palette = ColorConverter.complementary("#3498DB")
/// // Result: ["#3498DB", "#DB7534"]
///
/// // Check accessibility
/// let contrast = ColorConverter.contrastRatio("#000000", "#FFFFFF")
/// // Result: 21.0 (perfect contrast)
/// ```
public struct ColorConverter {
    
    /// Convert a color between different formats with automatic source detection.
    ///
    /// Automatically detects the source format (HEX, RGB, or HSL) and converts
    /// to the specified target format.
    ///
    /// ## Supported Formats
    /// - **HEX**: #FF5733, #F57 (3 or 6 digits)
    /// - **RGB**: rgb(255,87,51), rgba(255,87,51,0.8)
    /// - **HSL**: hsl(11,100%,60%), hsla(11,100%,60%,0.8)
    ///
    /// ## Example
    /// ```swift
    /// ColorConverter.convert("#FF5733", to: .rgb)     // → "rgb(255,87,51)"
    /// ColorConverter.convert("rgb(255,87,51)", to: .hsl)  // → "hsl(11,100%,60%)"
    /// ColorConverter.convert("hsl(11,100%,60%)", to: .hex) // → "#FF5733"
    /// ```
    ///
    /// - Parameters:
    ///   - color: Source color string (format auto-detected)
    ///   - format: Target color format
    /// - Returns: Converted color string, or nil if conversion fails
    public static func convert(_ color: String, to format: ColorFormat) -> String? {
        let normalized = color.normalizedColor
        
        // Auto-detect source format
        guard let sourceFormat = detectFormat(normalized) else {
            return nil
        }
        
        // Same format? Just return cleaned input
        if sourceFormat == format {
            return normalized
        }
        
        // Convert via RGB intermediate
        guard let rgb = parseToRGB(normalized, from: sourceFormat) else {
            return nil
        }
        
        return formatFromRGB(rgb, to: format)
    }
    
    /// Generate a complementary color palette (2 colors).
    ///
    /// Creates a high-contrast color pair using colors that are opposite
    /// on the color wheel. Perfect for accent colors and strong visual impact.
    ///
    /// ## Example
    /// ```swift
    /// let palette = ColorConverter.complementary("#3498DB")
    /// // Result: ["#3498DB", "#DB7534"]
    /// ```
    ///
    /// - Parameter baseColor: Base color for palette generation
    /// - Returns: Array of 2 complementary colors in HEX format
    public static func complementary(_ baseColor: String) -> [String] {
        guard let rgb = parseToRGB(baseColor.normalizedColor, from: detectFormat(baseColor.normalizedColor)) else {
            return []
        }
        
        let hsl = rgb.toHSL()
        let baseHex = formatHEX(rgb)
        let complementHue = (hsl.hue + 180).truncatingRemainder(dividingBy: 360)
        let complement = HSLColor(hue: complementHue, saturation: hsl.saturation, lightness: hsl.lightness)
        
        return [baseHex, formatHEX(complement.toRGB())]
    }
    
    /// Generate a triadic color palette (3 colors).
    ///
    /// Creates three evenly spaced colors on the color wheel. Offers vibrant
    /// contrast while maintaining harmony.
    ///
    /// ## Example
    /// ```swift
    /// let palette = ColorConverter.triadic("#FF5733")
    /// // Result: ["#FF5733", "#33FF57", "#5733FF"]
    /// ```
    ///
    /// - Parameter baseColor: Base color for palette generation
    /// - Returns: Array of 3 triadic colors in HEX format
    public static func triadic(_ baseColor: String) -> [String] {
        guard let rgb = parseToRGB(baseColor.normalizedColor, from: detectFormat(baseColor.normalizedColor)) else {
            return []
        }
        
        let hsl = rgb.toHSL()
        let baseHex = formatHEX(rgb)
        
        let hue2 = (hsl.hue + 120).truncatingRemainder(dividingBy: 360)
        let hue3 = (hsl.hue + 240).truncatingRemainder(dividingBy: 360)
        
        let color2 = HSLColor(hue: hue2, saturation: hsl.saturation, lightness: hsl.lightness)
        let color3 = HSLColor(hue: hue3, saturation: hsl.saturation, lightness: hsl.lightness)
        
        return [baseHex, formatHEX(color2.toRGB()), formatHEX(color3.toRGB())]
    }
    
    /// Generate a monochromatic color palette (multiple variations of one hue).
    ///
    /// Creates multiple shades, tints, and tones of the same hue by varying
    /// the lightness. Perfect for subtle, harmonious designs.
    ///
    /// ## Example
    /// ```swift
    /// let palette = ColorConverter.monochromatic("#3498DB", count: 5)
    /// // Result: ["#1B4F72", "#2E86C1", "#3498DB", "#5DADE2", "#AED6F1"]
    /// ```
    ///
    /// - Parameters:
    ///   - baseColor: Base color for palette generation
    ///   - count: Number of color variations to generate (default: 5)
    /// - Returns: Array of monochromatic colors in HEX format
    public static func monochromatic(_ baseColor: String, count: Int = 5) -> [String] {
        guard let rgb = parseToRGB(baseColor.normalizedColor, from: detectFormat(baseColor.normalizedColor)) else {
            return []
        }
        
        let hsl = rgb.toHSL()
        var colors: [String] = []
        
        for i in 0..<count {
            let lightness = 20.0 + (Double(i) * 60.0 / Double(count - 1))
            let monoHSL = HSLColor(hue: hsl.hue, saturation: hsl.saturation, lightness: lightness)
            colors.append(formatHEX(monoHSL.toRGB()))
        }
        
        return colors
    }
    
    /// Calculate the contrast ratio between two colors for accessibility.
    ///
    /// Returns a contrast ratio from 1.0 (no contrast) to 21.0 (maximum contrast).
    /// Essential for ensuring text readability and WCAG compliance.
    ///
    /// ## Accessibility Standards
    /// - **21.0**: Perfect contrast (black on white)
    /// - **7.0+**: AAA compliant (enhanced contrast)
    /// - **4.5+**: AA compliant (standard contrast)
    /// - **3.0+**: AA Large compliant (large text only)
    /// - **<3.0**: Fails accessibility standards
    ///
    /// ## Example
    /// ```swift
    /// let contrast = ColorConverter.contrastRatio("#000000", "#FFFFFF")
    /// // Result: 21.0 (perfect contrast)
    ///
    /// let contrast2 = ColorConverter.contrastRatio("#777777", "#FFFFFF")
    /// // Result: 4.6 (meets AA standards)
    /// ```
    ///
    /// - Parameters:
    ///   - foreground: Foreground color (text color)
    ///   - background: Background color
    /// - Returns: Contrast ratio, or nil if colors are invalid
    public static func contrastRatio(_ foreground: String, _ background: String) -> Double? {
        guard let fgRGB = parseToRGB(foreground.normalizedColor, from: detectFormat(foreground.normalizedColor)),
              let bgRGB = parseToRGB(background.normalizedColor, from: detectFormat(background.normalizedColor)) else {
            return nil
        }
        
        let fgLuminance = calculateLuminance(fgRGB)
        let bgLuminance = calculateLuminance(bgRGB)
        
        let lighter = max(fgLuminance, bgLuminance)
        let darker = min(fgLuminance, bgLuminance)
        
        return (lighter + 0.05) / (darker + 0.05)
    }
    
    /// Validate if a color string is properly formatted.
    ///
    /// Checks if the color string matches valid HEX, RGB, or HSL format patterns.
    ///
    /// ## Example
    /// ```swift
    /// ColorConverter.isValid("#FF5733")        // → true
    /// ColorConverter.isValid("rgb(255,87,51)") // → true
    /// ColorConverter.isValid("#ZZ5733")        // → false
    /// ```
    ///
    /// - Parameter color: Color string to validate
    /// - Returns: True if the color is valid, false otherwise
    public static func isValid(_ color: String) -> Bool {
        return detectFormat(color.normalizedColor) != nil
    }
}



extension ColorConverter {
    
    /// Detect the format of a color string
    internal static func detectFormat(_ color: String) -> ColorFormat? {
        let normalized = color.lowercased()
        
        if normalized.hasPrefix("#") && isValidHex(normalized) {
            return .hex
        } else if (normalized.hasPrefix("rgb(") || normalized.hasPrefix("rgba(")) && isValidRGB(normalized) {
            return .rgb
        } else if (normalized.hasPrefix("hsl(") || normalized.hasPrefix("hsla(")) && isValidHSL(normalized) {
            return .hsl
        }
        
        return nil
    }
    
    /// Validate HEX color format
    private static func isValidHex(_ hex: String) -> Bool {
        guard hex.hasPrefix("#") else { return false }
        let hexDigits = String(hex.dropFirst())
        
        guard [3, 6, 8].contains(hexDigits.count) else { return false }
        
        let hexSet = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        return hexDigits.unicodeScalars.allSatisfy { hexSet.contains($0) }
    }
    
    /// Validate RGB color format
    private static func isValidRGB(_ rgb: String) -> Bool {
        let pattern = rgb.contains("rgba") ?
            #"^rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(0|1|0?\.\d+)\s*\)$"# :
            #"^rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$"#
        
        guard rgb.matches(pattern) else { return false }
        
        // Extract and validate RGB values
        let numbers = rgb.components(separatedBy: CharacterSet(charactersIn: "(),rgba "))
            .compactMap { Int($0) }
        
        return numbers.count >= 3 && numbers[0...2].allSatisfy { $0 >= 0 && $0 <= 255 }
    }
    
    /// Validate HSL color format
    private static func isValidHSL(_ hsl: String) -> Bool {
        let pattern = hsl.contains("hsla") ?
            #"^hsla\(\s*(\d+)\s*,\s*(\d+)%\s*,\s*(\d+)%\s*,\s*(0|1|0?\.\d+)\s*\)$"# :
            #"^hsl\(\s*(\d+)\s*,\s*(\d+)%\s*,\s*(\d+)%\s*\)$"#
        
        guard hsl.matches(pattern) else { return false }
        
        // Extract and validate HSL values
        let pattern2 = #"(\d+)"#
        let regex = try? NSRegularExpression(pattern: pattern2)
        let matches = regex?.matches(in: hsl, range: NSRange(hsl.startIndex..., in: hsl)) ?? []
        
        let numbers = matches.compactMap { match -> Int? in
            guard let range = Range(match.range, in: hsl) else { return nil }
            return Int(String(hsl[range]))
        }
        
        guard numbers.count >= 3 else { return false }
        
        // Validate ranges: hue (0-360), saturation (0-100), lightness (0-100)
        return numbers[0] >= 0 && numbers[0] <= 360 &&  // hue
               numbers[1] >= 0 && numbers[1] <= 100 &&  // saturation
               numbers[2] >= 0 && numbers[2] <= 100     // lightness
    }
    
    /// Parse color string to RGB
    internal static func parseToRGB(_ color: String, from format: ColorFormat?) -> RGBColor? {
        guard let format = format else { return nil }
        
        switch format {
        case .hex:
            return parseHEX(color)
        case .rgb:
            return parseRGB(color)
        case .hsl:
            return parseHSL(color)?.toRGB()
        }
    }
    
    /// Parse HEX color string
    private static func parseHEX(_ hex: String) -> RGBColor? {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgb) else { return nil }
        
        switch hexString.count {
        case 3: // #RGB
            let r = Int((rgb >> 8) & 0xF) * 17
            let g = Int((rgb >> 4) & 0xF) * 17
            let b = Int(rgb & 0xF) * 17
            return RGBColor(red: r, green: g, blue: b)
        case 6: // #RRGGBB
            let r = Int((rgb >> 16) & 0xFF)
            let g = Int((rgb >> 8) & 0xFF)
            let b = Int(rgb & 0xFF)
            return RGBColor(red: r, green: g, blue: b)
        case 8: // #RRGGBBAA
            let r = Int((rgb >> 24) & 0xFF)
            let g = Int((rgb >> 16) & 0xFF)
            let b = Int((rgb >> 8) & 0xFF)
            let a = Double(rgb & 0xFF) / 255.0
            return RGBColor(red: r, green: g, blue: b, alpha: a)
        default:
            return nil
        }
    }
    
    /// Parse RGB color string
    private static func parseRGB(_ rgb: String) -> RGBColor? {
        // Extract numbers from rgb(r,g,b) or rgba(r,g,b,a)
        let pattern = #"(\d+(?:\.\d+)?)"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let matches = regex?.matches(in: rgb, range: NSRange(rgb.startIndex..., in: rgb)) ?? []
        
        let numbers = matches.compactMap { match -> Double? in
            guard let range = Range(match.range, in: rgb) else { return nil }
            return Double(String(rgb[range]))
        }
        
        guard numbers.count >= 3 else { return nil }
        
        let r = Int(numbers[0])
        let g = Int(numbers[1])
        let b = Int(numbers[2])
        let a = numbers.count > 3 ? numbers[3] : 1.0
        
        return RGBColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Parse HSL color string
    private static func parseHSL(_ hsl: String) -> HSLColor? {
        // Extract numbers from hsl(h,s%,l%) or hsla(h,s%,l%,a)
        let pattern = #"(\d+(?:\.\d+)?)"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let matches = regex?.matches(in: hsl, range: NSRange(hsl.startIndex..., in: hsl)) ?? []
        
        let numbers = matches.compactMap { match -> Double? in
            guard let range = Range(match.range, in: hsl) else { return nil }
            return Double(String(hsl[range]))
        }
        
        guard numbers.count >= 3 else { return nil }
        
        let h = numbers[0]
        let s = numbers[1]
        let l = numbers[2]
        let a = numbers.count > 3 ? numbers[3] : 1.0
        
        return HSLColor(hue: h, saturation: s, lightness: l, alpha: a)
    }
    
    /// Format RGB to target format
    internal static func formatFromRGB(_ rgb: RGBColor, to format: ColorFormat) -> String? {
        switch format {
        case .hex:
            return formatHEX(rgb)
        case .rgb:
            return formatRGB(rgb)
        case .hsl:
            return formatHSL(rgb.toHSL())
        }
    }
    
    /// Format RGB as HEX
    internal static func formatHEX(_ rgb: RGBColor) -> String {
        if rgb.alpha < 1.0 {
            return String(format: "#%02X%02X%02X%02X", rgb.red, rgb.green, rgb.blue, Int(rgb.alpha * 255))
        } else {
            return String(format: "#%02X%02X%02X", rgb.red, rgb.green, rgb.blue)
        }
    }
    
    /// Format RGB as RGB string
    private static func formatRGB(_ rgb: RGBColor) -> String {
        if rgb.alpha < 1.0 {
            return "rgba(\(rgb.red),\(rgb.green),\(rgb.blue),\(rgb.alpha))"
        } else {
            return "rgb(\(rgb.red),\(rgb.green),\(rgb.blue))"
        }
    }
    
    /// Format HSL as HSL string
    private static func formatHSL(_ hsl: HSLColor) -> String {
        if hsl.alpha < 1.0 {
            return "hsla(\(Int(hsl.hue.rounded())),\(Int(hsl.saturation.rounded()))%,\(Int(hsl.lightness.rounded()))%,\(hsl.alpha))"
        } else {
            return "hsl(\(Int(hsl.hue.rounded())),\(Int(hsl.saturation.rounded()))%,\(Int(hsl.lightness.rounded()))%)"
        }
    }
    
    /// Calculate relative luminance for contrast ratio
    private static func calculateLuminance(_ rgb: RGBColor) -> Double {
        let r = sRGBToLinear(Double(rgb.red) / 255.0)
        let g = sRGBToLinear(Double(rgb.green) / 255.0)
        let b = sRGBToLinear(Double(rgb.blue) / 255.0)
        
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
    
    /// Convert sRGB to linear RGB for luminance calculation
    private static func sRGBToLinear(_ value: Double) -> Double {
        if value <= 0.03928 {
            return value / 12.92
        } else {
            return pow((value + 0.055) / 1.055, 2.4)
        }
    }
    
}
