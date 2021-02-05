//
//  Look+Autoadjust.swift
//  Lux
//
//  Created by Mark Maxwell on the New LUX
//  Copyright © 2020 maxwell.design. All rights reserved.
//

import UIKit

public extension Look {
    func autoAdjustPalette() {
        Self.autoAdjust(look: self)
    }

    static func autoAdjust(look: Look) {
        look.spec = autoAdjustSpec(spec: look.spec, isDark: look.scheme == .dark)
        look.spec.elevation.base = -0.13
    }

    static func autoAdjustSpec(spec: Specification, isDark: Bool) -> Specification {
        var result = spec
        result.color.background = autoAdjust(color: spec.color.background, isDark: isDark, maxSaturation: 0.33, maxBrightness: isDark ? 0.5 : 0.9)
        result.color.background2 = autoAdjust(color: spec.color.background2, isDark: isDark, maxSaturation: 0.13, maxBrightness: isDark ? 0.66 : 0.86)
        result.color.background3 = autoAdjust(color: spec.color.background3, isDark: isDark, maxSaturation: 0.5, maxBrightness: isDark ? 0.25 : 0.5)

        result.color.primary = autoAdjust(color: spec.color.primary, isDark: isDark, maxSaturation: isDark ? 0.8 : 0.8, maxBrightness: 0.9)
        result.color.secondary = autoAdjust(color: spec.color.secondary, isDark: isDark, maxSaturation: isDark ? 0.7 : 0.7, maxBrightness: 0.8)
        result.color.tertiary = autoAdjust(color: spec.color.tertiary, isDark: isDark, maxSaturation: isDark ? 0.66 : 0.66, maxBrightness: 0.7)
        return result
    }

    static func autoAdjust(color: UIColor, isDark: Bool, maxSaturation: CGFloat = 1.0, maxBrightness: CGFloat = 1.0) -> UIColor {
        let hsb = HueColor(color: color)
        let saturation = isDark ? min(hsb.saturation, maxSaturation) : min(hsb.saturation, maxSaturation)
        let brightness = min(hsb.brightness, maxBrightness)

        return HueColor(hue: hsb.hue, saturation: saturation, brightness: brightness).toUIColor()
    }
}
