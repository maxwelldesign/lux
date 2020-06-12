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
        result.color.background = autoAdjust(color: spec.color.background.uiColor(), isDark: isDark, maxSaturation: 0.33, maxBrightness: isDark ? 0.5 : 0.9).uiColor
        result.color.background2 = autoAdjust(color: spec.color.background2.uiColor(), isDark: isDark, maxSaturation: 0.13, maxBrightness: isDark ? 0.66 : 0.86).uiColor
        result.color.background3 = autoAdjust(color: spec.color.background3.uiColor(), isDark: isDark, maxSaturation: 0.5, maxBrightness: isDark ? 0.25 : 0.5).uiColor

        result.color.primary = autoAdjust(color: spec.color.primary.uiColor(), isDark: isDark, maxSaturation: isDark ? 0.8 : 0.8, maxBrightness: 0.9).uiColor
        result.color.secondary = autoAdjust(color: spec.color.secondary.uiColor(), isDark: isDark, maxSaturation: isDark ? 0.7 : 0.7, maxBrightness: 0.8).uiColor
        result.color.tertiary = autoAdjust(color: spec.color.tertiary.uiColor(), isDark: isDark, maxSaturation: isDark ? 0.66 : 0.66, maxBrightness: 0.7).uiColor
        return result
    }

    static func autoAdjust(color: UIColor, isDark: Bool, maxSaturation: CGFloat = 1.0, maxBrightness: CGFloat = 1.0) -> UIColor {
        let hsb = HueColor(color: color)
        let saturation = isDark ? min(hsb.saturation, maxSaturation) : min(hsb.saturation, maxSaturation)
        let brightness = min(hsb.brightness, maxBrightness)

        return HueColor(hue: hsb.hue, saturation: saturation, brightness: brightness).toUIColor()
    }
}
