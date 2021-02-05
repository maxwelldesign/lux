//
//  UIFont+extension.swift
//  FlyEditor
//
//  Created by mark maxwell on 1/3/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI
import UIKit

public extension UIFont {
    private enum CustomFont {
        static var fontFamily = "Avenir"
    }

    /// Returns a bold version of `self`
    var bolded: UIFont {
        fontDescriptor.withSymbolicTraits(.traitBold)
            .map { UIFont(descriptor: $0, size: 0) } ?? self
    }

    /// Returns an italic version of `self`
    var italicized: UIFont {
        fontDescriptor.withSymbolicTraits(.traitItalic)
            .map { UIFont(descriptor: $0, size: 0) } ?? self
    }

    /// Returns a scaled version of `self`
    func scaled(scaleFactor: CGFloat) -> UIFont {
        let newDescriptor = fontDescriptor.withSize(fontDescriptor.pointSize * scaleFactor)
        return UIFont(descriptor: newDescriptor, size: 0)
    }

    class func preferredCustomFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        // we are using the UIFontDescriptor which is less expensive than creating an intermediate UIFont
        let systemFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)

        let customFontDescriptor = UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.family: CustomFont.fontFamily,
            UIFontDescriptor.AttributeName.size: systemFontDescriptor.pointSize, // use the font size of the default dynamic font
        ])

        // return font of new family with same size as the preferred system font
        return UIFont(descriptor: customFontDescriptor, size: 0)
    }
}

public extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF

        self.init(red: Double(r) / 0xFF, green: Double(g) / 0xFF, blue: Double(b) / 0xFF)
    }
}

extension EdgeInsets {
    static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
}

public extension UIColor {
    var paint: Color {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}

public extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x0000_00FF) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension Color {
    public func uiColor() -> UIColor {
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        if #available(iOS 14.0, *) {
            UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        } else {
            // Fallback on earlier versions
            let scanner = Scanner(string: description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
            var hexNumber: UInt64 = 0
            let result = scanner.scanHexInt64(&hexNumber)
            if result {
                r = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                a = CGFloat(hexNumber & 0x0000_00FF) / 255
            }
        }

        return (r, g, b, a)
    }
}

public extension Font {
    static func textSize(_ textStyle: UIFont.TextStyle) -> CGFloat {
        UIFont.preferredFont(forTextStyle: textStyle).pointSize
    }
}

public extension UIFont.TextStyle {
    static let title = UIFont.TextStyle.title1
    static let caption = UIFont.TextStyle.caption1
    var displayName: String {
        switch self {
        case .largeTitle:
            return "Large Title"
        case .title, .title1, .title2, .title3:
            return "Title"
        case .headline:
            return "Headline"
        case .subheadline:
            return "Sub Headline"
        case .body:
            return "Body"
        case .callout:
            return "Callout"
        case .caption, .caption1, .caption2:
            return "Caption"
        case .footnote:
            return "Footnote"
        default:
            return "Undefined Trait"
        }
    }
}

public extension UIColor {
    // get a complementary color to this color
    // https://gist.github.com/klein-artur/025a0fa4f167a648d9ea
    var complementary: UIColor {
        let ciColor = CIColor(color: self)

        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue

        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: ciColor.alpha)
    }

    // perceptive luminance
    // https://stackoverflow.com/questions/1855884/determine-font-color-based-on-background-color
    var contrast: UIColor {
        let ciColor = CIColor(color: self)

        let compRed: CGFloat = ciColor.red * 0.299
        let compGreen: CGFloat = ciColor.green * 0.587
        let compBlue: CGFloat = ciColor.blue * 0.114

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = min(1.0, max(compRed + compGreen + compBlue, 0.0))

        // bright colors - black font
        // dark colors - white font
        let color: UIColor = luminance < 0.455 ? Look.current.surface.foregroundLight.uiColor() : Look.current.surface.foregroundDark.uiColor()

        return color.withAlphaComponent(ciColor.alpha)
    }

    func contrast(threshold: CGFloat = 0.65, bright: UIColor = Look.current.surface.foregroundLight.uiColor(), dark: UIColor = Look.current.surface.foregroundDark.uiColor()) -> UIColor {
        let ciColor = CIColor(color: self)

        let compRed = 0.299 * ciColor.red
        let compGreen = 0.587 * ciColor.green
        let compBlue = 0.114 * ciColor.blue

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = (compRed + compGreen + compBlue)
        // let rounded = CGFloat( round(1000 * luminance) / 1000 )
        return luminance < threshold ? bright : dark
    }
}

extension UIColor {
    func hue(plus value: CGFloat = 0) -> UIColor {
        let color = HueColor(color: self)
        let intensity = (color.hue + value).doubleValue.truncatingRemainder(dividingBy: 1.0)

        let newValue = min(max(intensity, 0.0), 1.0)

        let result = color.withHue(CGFloat(newValue))
        return result.toUIColor()
    }

    func hue(by value: CGFloat = 0) -> UIColor {
        let color = HueColor(color: self)
        let intensity = (color.hue + value).doubleValue.truncatingRemainder(dividingBy: 1.0)

        let newValue = min(max(intensity, 0.0), 1.0)

        let result = color.withHue(CGFloat(newValue))
        return result.toUIColor()
    }

    func brightness(plus value: CGFloat = 0) -> UIColor {
        let color = HueColor(color: self)
        let intensity = color.brightness + value
        let newValue = min(max(intensity, 0.0), 1.0)

        let result = color.withBrightness(newValue)
        return result.toUIColor()
    }

    func brightness(by value: CGFloat = 0) -> UIColor {
        let color = HueColor(color: self)
        let intensity = color.brightness * value
        let newValue = min(max(intensity, 0.0), 1.0)

        let result = color.withBrightness(newValue)
        return result.toUIColor()
    }

    func saturation(plus value: CGFloat = 0) -> UIColor {
        let color = HueColor(color: self)
        let intensity = color.saturation + value
        let newValue = min(max(intensity, 0.0), 1.0)

        let result = color.withSaturation(newValue)
        return result.toUIColor()
    }

    func saturation(by value: CGFloat = 0) -> UIColor {
        let color = HueColor(color: self)
        let intensity = color.saturation * value
        let newValue = min(max(intensity, 0.0), 1.0)

        let result = color.withSaturation(newValue)
        return result.toUIColor()
    }
}

public extension Color {
    var contrast: Color {
        uiColor().contrast.paint
    }
}

public extension UIUserInterfaceStyle {
    var lookColorScheme: Look.Scheme {
        self == .light ? .light : .dark
    }
}

public extension CGFloat {
    var double: CGFloat {
        self * 2.0
    }

    var triple: CGFloat {
        self * 2.0
    }

    var quadruple: CGFloat {
        self * 2.0
    }

    var quintuple: CGFloat {
        self * 2.0
    }
}

public extension CGFloat {
    var half: CGFloat {
        self * 0.5
    }

    var quarter: CGFloat {
        self * 0.25
    }

    var eighth: CGFloat {
        self * 0.125
    }
}

public extension Double {
    var cgFloat: CGFloat {
        CGFloat(self)
    }
}

public extension CGFloat {
    static var eighth: CGFloat {
        0.125
    }

    static var quarter: CGFloat {
        0.25
    }

    static var half: CGFloat {
        0.5
    }

    static var base: CGFloat {
        1.0
    }
}

public extension CGFloat {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }

    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
}

/// Represetation of a color in HSB (Hue, Saturation, Brightness) color model. This model can be directly converted to and from RGB model.
/// - Note: HSB is better representation for color picker than RGB as its components often maps directly to user interactions.
public struct HueColor {
    /// Hue value in interval <0, 1>
    public let hue: CGFloat
    /// Saturation value in interval <0, 1>
    public let saturation: CGFloat
    /// Brightness value in interval <0, 1>
    public let brightness: CGFloat
    /// Alpha value in interval <0, 1>
    public let alpha: CGFloat

    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1) {
        self.hue = max(0, min(1, hue))
        self.saturation = max(0, min(1, saturation))
        self.brightness = max(0, min(1, brightness))
        self.alpha = max(0, min(1, alpha))
    }
}

public extension HueColor {
    /// RGB representation of this HSBColor
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        return rgbFrom(hue: hue, saturation: saturation, brightness: brightness)
    }

    /// Initializes `HSBColor` instance that represents the same color as passed color.
    ///
    /// - Parameter color: A color to construct an equivalent `HSBColor` from.
    init(color: UIColor) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func asTuple() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        return (hue, saturation, brightness, alpha)
    }

    func asTupleNoAlpha() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        return (hue, saturation, brightness)
    }

    /// Returs `UIColor` that represents equivalent color as this instance.
    ///
    /// - Returns: `UIColor` equivalent to this `HSBColor`.
    func toUIColor() -> UIColor {
        UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func withHue(_ hue: CGFloat, andSaturation saturation: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func withSaturation(_ saturation: CGFloat, andBrightness brightness: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func withHue(_ hue: CGFloat, andBrightness brightness: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func withHue(_ hue: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func withSaturation(_ saturation: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func withBrightness(_ brightness: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// Computes new HSL color based on given RGB values while keeping alpha value of original color.
    /// - Note: If the RGB values given specify achromatic color the hue of original color is kept.
    /// - Parameter red: Red component of new color specified as value from <0, 1>
    /// - Parameter green: Green component of new color specified as value from <0, 1>
    /// - Parameter blue: Blue component of new color specified as value from <0, 1>
    /// - Returns: Color specified by the given RGB values with the same alpha as current color.
    func withRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> HueColor {
        let red_ = min(1, max(0, red))
        let green_ = min(1, max(0, green))
        let blue_ = min(1, max(0, blue))

        let max_ = fmax(red_, fmax(green_, blue_))
        let min_ = fmin(red_, fmin(green_, blue_))

        var h: CGFloat = 0, b = max_
        let d = max_ - min_
        let s = max_ == 0 ? 0 : d / max_

        guard max_ != min_ else {
            return HueColor(hue: hue, saturation: 1 - max_, brightness: b, alpha: alpha) // achromatic: keep the original hue (that is why this is an extension)
        }
        if max_ == red_ {
            h = (green_ - blue) / d + (green_ < blue_ ? 6 : 0)
        } else if max_ == green_ {
            h = (blue_ - red_) / d + 2
        } else if max_ == blue_ {
            h = (red_ - green_) / d + 4
        }
        h /= 6
        return HueColor(hue: h, saturation: s, brightness: b, alpha: alpha)
    }

    func withRed(_ red: CGFloat) -> HueColor {
        let (_, g, b) = rgb
        return withRGB(red: red, green: g, blue: b)
    }

    func withGreen(_ green: CGFloat) -> HueColor {
        let (r, _, b) = rgb
        return withRGB(red: r, green: green, blue: b)
    }

    func withBlue(_ blue: CGFloat) -> HueColor {
        let (r, g, _) = rgb
        return withRGB(red: r, green: g, blue: blue)
    }

    func withAlpha(_ alpha: CGFloat) -> HueColor {
        HueColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func rgbFrom(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let hPrime = Int(hue * 6)
        let f = hue * 6 - CGFloat(hPrime)
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - f * saturation)
        let t = brightness * (1 - (1 - f) * saturation)

        switch hPrime % 6 {
        case 0: return (brightness, t, p)
        case 1: return (q, brightness, p)
        case 2: return (p, brightness, t)
        case 3: return (p, q, brightness)
        case 4: return (t, p, brightness)
        default: return (brightness, p, q)
        }
    }
}

extension HueColor: Hashable {
    public static func == (l: HueColor, r: HueColor) -> Bool {
        l.hue == r.hue && l.saturation == r.saturation && l.brightness == r.brightness && l.alpha == r.alpha
    }
}

public extension CGFloat {
    var doubleValue: Double {
        Double(self)
    }
}

extension UnitPoint {
    var name: String {
        switch self {
        case .topLeading:
            return "Top Leading"
        case .top:
            return "Top"
        case .topTrailing:
            return "Top Trailing"

        case .leading:
            return "Leading"
        case .center:
            return "Center"
        case .trailing:
            return "Trailing"

        case .bottomLeading:
            return "Bottom Leading"
        case .bottom:
            return "Bottom"
        case .bottomTrailing:
            return "Bottom Trailing"

        default:
            return "undefined"
        }
    }
}

extension String {
    func base64Encoded() -> String {
        let plainData = data(using: .utf8)
        let base64String = plainData?.base64EncodedString()
        return base64String!
    }

    func base64Decoded() -> String {
        guard
            let data = Data(base64Encoded: self),
            let decodedString = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return decodedString
    }
}

extension String {
    var alphanumeric: String {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
}
