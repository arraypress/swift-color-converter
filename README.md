# Swift Color Converter

A clean, focused color converter for everyday design and development workflows. It converts between HEX, RGB, and HSL with automatic source-format detection, generates harmonious color palettes (complementary, triadic, and monochromatic), and measures WCAG accessibility contrast ratios — making it ideal for design tooling and Shortcuts integration.

## Features

- 🎨 **HEX ↔ RGB ↔ HSL** — convert between all three formats with `convert(_:to:)`
- 🔍 **Auto format detection** — the source format is inferred from the input string
- 🌗 **Alpha support** — handles `rgba`, `hsla`, and 8-digit HEX values
- 🤝 **Complementary palettes** — `complementary` returns an opposite-on-the-wheel pair
- 🔺 **Triadic palettes** — `triadic` returns three evenly spaced hues
- 🌈 **Monochromatic palettes** — `monochromatic` returns shades/tints of a single hue
- ♿ **WCAG contrast ratio** — `contrastRatio` computes accessibility contrast from 1.0 to 21.0
- ✅ **Validation** — `isValid` confirms a color string is well-formed
- 🧱 **Typed color models** — `RGBColor` and `HSLColor` value types with clamping
- 🧵 **Sendable & Equatable** — value types ready for concurrent use

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.1+
- Xcode 16.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-color-converter.git", from: "1.0.0")
]
```

## Usage

### Convert Between Formats

```swift
import ColorConverter

let rgb = ColorConverter.convert("#FF5733", to: .rgb)      // "rgb(255,87,51)"
let hsl = ColorConverter.convert("rgb(255,87,51)", to: .hsl) // "hsl(11,100%,60%)"
let hex = ColorConverter.convert("hsl(11,100%,60%)", to: .hex) // "#FF5733"
```

### Generate Palettes

```swift
import ColorConverter

let complementary = ColorConverter.complementary("#3498DB")          // ["#3498DB", "#DB7534"]
let triadic = ColorConverter.triadic("#FF5733")                      // three colors
let monochromatic = ColorConverter.monochromatic("#3498DB", count: 5) // five shades
```

### Check Accessibility Contrast

```swift
import ColorConverter

let contrast = ColorConverter.contrastRatio("#000000", "#FFFFFF") // 21.0
let aa = ColorConverter.contrastRatio("#777777", "#FFFFFF")       // ~4.6 (meets WCAG AA)
```

### Validate Colors

```swift
import ColorConverter

ColorConverter.isValid("#FF5733")        // true
ColorConverter.isValid("rgb(255,87,51)") // true
ColorConverter.isValid("#ZZ5733")        // false
```

## How It Works

`ColorConverter` auto-detects the input format (HEX, RGB, or HSL), parses it into an intermediate `RGBColor`, and re-formats it to the requested target. Palette generation converts to HSL, rotates the hue (or varies lightness for monochromatic), and converts back to HEX. Contrast ratios are computed from relative luminance using the WCAG sRGB-to-linear formula.

## Models

### `RGBColor`

| Property | Type | Description |
|----------|------|-------------|
| `red` | `Int` | Red channel, clamped 0–255 |
| `green` | `Int` | Green channel, clamped 0–255 |
| `blue` | `Int` | Blue channel, clamped 0–255 |
| `alpha` | `Double` | Alpha, clamped 0.0–1.0 |

### `HSLColor`

| Property | Type | Description |
|----------|------|-------------|
| `hue` | `Double` | Hue in degrees (0–360, wrapped) |
| `saturation` | `Double` | Saturation, clamped 0–100 |
| `lightness` | `Double` | Lightness, clamped 0–100 |
| `alpha` | `Double` | Alpha, clamped 0.0–1.0 |

`ColorFormat` (`.hex`, `.rgb`, `.hsl`) and `PaletteType` (`.complementary`, `.triadic`, `.monochromatic`) enums provide descriptive metadata such as `description`, `example`, and `colorCount`.

## Use Cases

- Design tools and color pickers
- Theme generation and accessibility checking
- Shortcuts and voice-command automations
- Developer utilities for converting color values

## Testing

```bash
swift test
```

The test suite covers format detection and conversion accuracy across HEX/RGB/HSL, palette generation, contrast-ratio calculations, validation, and alpha handling.

## License

MIT License — see LICENSE file for details.

## Author

Created by David Sherlock ([ArrayPress](https://github.com/arraypress)) in 2026.
