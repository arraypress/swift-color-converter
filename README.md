# Swift Color Converter

A clean, focused color converter for everyday design and development workflows. Perfect for Shortcuts integration and voice commands.

## Features

- 🎨 **Simple Color Conversion** - Convert between HEX, RGB, and HSL
- 🎯 **Smart Palette Generation** - Create complementary, triadic, and monochromatic color schemes
- ♿ **Accessibility Checking** - WCAG contrast ratio calculations
- 🗣️ **Voice-Friendly** - Perfect for Siri Shortcuts
- 🔍 **Auto-Detection** - Automatically detects source color format
- ⚡ **Lightweight** - Focused on the essentials, no bloat

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-color-converter.git", from: "1.0.0")
]
```

## Quick Start

```swift
import ColorConverter

// Convert colors (auto-detects source format)
let rgb = ColorConverter.convert("#FF5733", to: .rgb)
// Result: "rgb(255,87,51)"

let hsl = ColorConverter.convert("rgb(255,87,51)", to: .hsl)
// Result: "hsl(11,100%,60%)"

// Generate color palettes
let complementary = ColorConverter.complementary("#3498DB")
// Result: ["#3498DB", "#DB7534"]

let triadic = ColorConverter.triadic("#FF5733")
// Result: ["#FF5733", "#33FF57", "#5733FF"]

let monochromatic = ColorConverter.monochromatic("#2ECC71", count: 5)
// Result: ["#1B7943", "#2ECC71", "#58D68D", "#85E0A3", "#B2EAC2"]

// Check accessibility
let contrast = ColorConverter.contrastRatio("#000000", "#FFFFFF")
// Result: 21.0 (perfect contrast)

// Validate colors
let isValid = ColorConverter.isValid("#FF5733")
// Result: true
```

## Supported Formats

- **HEX**: `#FF5733`, `#F57` (3 or 6 digits), `#FF5733CC` (with alpha)
- **RGB**: `rgb(255,87,51)`, `rgba(255,87,51,0.8)`
- **HSL**: `hsl(11,100%,60%)`, `hsla(11,100%,60%,0.8)`

## Color Palettes

### Complementary
Creates two colors that are opposite on the color wheel. Perfect for high contrast and visual impact.

```swift
let palette = ColorConverter.complementary("#3498DB")
// Result: ["#3498DB", "#DB7534"]
```

### Triadic
Creates three evenly spaced colors on the color wheel. Offers vibrant contrast while maintaining harmony.

```swift
let palette = ColorConverter.triadic("#FF5733")
// Result: ["#FF5733", "#33FF57", "#5733FF"]
```

### Monochromatic
Creates variations of the same hue with different lightness values. Perfect for subtle, harmonious designs.

```swift
let palette = ColorConverter.monochromatic("#2ECC71", count: 5)
// Result: 5 variations from dark to light
```

## Accessibility

Check contrast ratios according to WCAG guidelines:

```swift
let contrast = ColorConverter.contrastRatio("#333333", "#FFFFFF")

if contrast >= 7.0 {
    print("AAA compliant (enhanced)")
} else if contrast >= 4.5 {
    print("AA compliant (standard)")
} else if contrast >= 3.0 {
    print("AA Large compliant (large text only)")
} else {
    print("Fails accessibility standards")
}
```

## Shortcuts Integration

Perfect for Siri voice commands:

```swift
import AppIntents

struct ConvertColorIntent: AppIntent {
    static var title: LocalizedStringResource = "Convert Color"
    
    @Parameter(title: "Color") var color: String
    @Parameter(title: "To Format") var format: String
    
    func perform() async throws -> some IntentResult {
        let targetFormat: ColorFormat
        switch format.lowercased() {
        case "rgb": targetFormat = .rgb
        case "hsl": targetFormat = .hsl
        default: targetFormat = .hex
        }
        
        let result = ColorConverter.convert(color, to: targetFormat)
        return .result(value: result ?? "Conversion failed")
    }
}
```

**Voice Commands:**
- *"Hey Siri, convert #FF5733 to RGB"*
- *"Hey Siri, generate complementary colors for blue"*
- *"Hey Siri, check contrast between black and white"*

## Real-World Examples

### Web Development
```swift
// Brand color in different formats
let brandHex = "#3498DB"
let brandRGB = ColorConverter.convert(brandHex, to: .rgb)  // For CSS
let brandHSL = ColorConverter.convert(brandHex, to: .hsl)  // For manipulation

// Generate theme colors
let accentColors = ColorConverter.complementary(brandHex)
```

### Design Workflows
```swift
// Create a color scheme
let baseColor = "#E74C3C"
let complementary = ColorConverter.complementary(baseColor)    // High contrast
let triadic = ColorConverter.triadic(baseColor)               // Balanced trio
let variations = ColorConverter.monochromatic(baseColor)      // Subtle range
```

### Accessibility Compliance
```swift
// Ensure your design meets standards
let textColor = "#2C3E50"
let backgroundColor = "#ECF0F1"
let contrast = ColorConverter.contrastRatio(textColor, backgroundColor)

if contrast >= 4.5 {
    print("✅ Meets WCAG AA standards")
} else {
    print("❌ Consider using darker text or lighter background")
}
```

## API Reference

### Core Functions

```swift
// Convert between formats (auto-detects source)
static func convert(_ color: String, to format: ColorFormat) -> String?

// Generate color palettes
static func complementary(_ baseColor: String) -> [String]
static func triadic(_ baseColor: String) -> [String]
static func monochromatic(_ baseColor: String, count: Int = 5) -> [String]

// Check accessibility
static func contrastRatio(_ foreground: String, _ background: String) -> Double?

// Validate color strings
static func isValid(_ color: String) -> Bool
```

### Supported Formats

```swift
enum ColorFormat {
    case hex    // #FF5733
    case rgb    // rgb(255,87,51)
    case hsl    // hsl(11,100%,60%)
}
```

## Design Philosophy

This library follows the principle of **doing one thing really well**. Instead of being a comprehensive color science toolkit, it focuses on the most common real-world color conversion needs:

✅ **What it does**: Convert between the 3 most-used color formats, generate useful palettes, check accessibility
❌ **What it doesn't**: Print colors (CMYK), color science (LAB), subjective named colors, complex analysis

**Result**: A tool that's simple to use, reliable, and perfect for everyday design workflows.

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 16.0+

## Performance

- **Basic conversion**: ~0.001ms per conversion
- **Palette generation**: ~0.01ms for 5 colors
- **Contrast calculation**: ~0.0005ms per calculation
- **Memory usage**: ~10KB (lightweight and efficient)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Made for designers and developers who want simple, reliable color conversion without the complexity.**
