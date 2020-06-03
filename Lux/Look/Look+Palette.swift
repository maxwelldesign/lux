//
//  Look+Palette.swift
//  Styling
//
//  Created by mark maxwell on 1/5/20.
//  Copyright © 2020 eonflux. All rights reserved.
//
import SwiftUI

public protocol PaletteProtocol {
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }

    var label: Color { get }
    var label2: Color { get }
    var label3: Color { get }
    var label4: Color { get }

    var fill: Color { get }
    var fill2: Color { get }
    var fill3: Color { get }
    var fill4: Color { get }

    var shadow: Color { get }

    var tint: Color { get }
    var tint2: Color { get }
    var tint3: Color { get }

    var background: Color { get }
    var background2: Color { get }
    var background3: Color { get }

    var group: Color { get }
    var group2: Color { get }
    var group3: Color { get }
}

public protocol SurfaceProviderProtocol {
    var spec: Look.Specification { get }
    var priority: Look.Priority { get }
    var palette: PaletteProtocol { get }

    var canvas: Color { get }
    var normal: Color { get }
    var accent: Color { get }
    var active: Color { get }
    var contrast: Color { get }

    var foregroundCanvas: Color { get }
    var foregroundNormal: Color { get }
    var foregroundAccent: Color { get }
    var foregroundActive: Color { get }
    var foregroundContrast: Color { get }

    var foregroundLight: Color { get }
    var foregroundDark: Color { get }

    func canvas(_ elevation: Look.Elevation) -> Color
    func normal(_ elevation: Look.Elevation) -> Color
    func accent(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color
    func active(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color
    func contrast(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color

    func foregroundCanvas(_ elevation: Look.Elevation) -> Color
    func foregroundNormal(_ elevation: Look.Elevation) -> Color
    func foregroundAccent(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color
    func foregroundActive(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color
    func foregroundContrast(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color

    func foregroundLight(_ elevation: Look.Elevation) -> Color
    func foregroundDark(_ elevation: Look.Elevation) -> Color

    func render(color: Color, at elevation: Look.Elevation) -> Color
}

public extension SurfaceProviderProtocol {
    var canvas: Color { canvas(.normal) }
    var normal: Color { normal(.normal) }
    var accent: Color { accent(.normal, prio: nil) }
    var active: Color { active(.normal, prio: nil) }
    var contrast: Color { contrast(.normal, prio: nil) }

    var foregroundCanvas: Color { foregroundCanvas(.normal) }
    var foregroundNormal: Color { foregroundNormal(.normal) }
    var foregroundAccent: Color { foregroundAccent(.normal, prio: nil) }
    var foregroundActive: Color { foregroundActive(.normal, prio: nil) }
    var foregroundContrast: Color { foregroundContrast(.normal, prio: nil) }

    var foregroundLight: Color { foregroundLight(.normal) }
    var foregroundDark: Color { foregroundDark(.normal) }
}

public extension SurfaceProviderProtocol {
    func render(color: Color, at elevation: Look.Elevation) -> Color {
        color.lighting(spec: spec, at: elevation)
    }

    func accent(_ elevation: Look.Elevation, prio _: Look.Priority?) -> Color {
        render(color: palette.background3, at: elevation)
    }

    func active(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color {
        let result: Color
        switch prio ?? priority {
        case .primary:
            result = palette.primary
        case .secondary:
            result = palette.secondary
        case .tertiary:
            result = palette.tertiary
        }

        return render(color: result, at: elevation)
    }

    func contrast(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color {
        render(color: active(.normal, prio: prio), at: elevation)
            .uiColor()
            .contrast(
                bright: foregroundLight.uiColor(),
                dark: foregroundDark.uiColor()
            ).uiColor
    }
}

public extension SurfaceProviderProtocol {
    func canvas(_ elevation: Look.Elevation) -> Color {
        render(color: palette.background, at: elevation)
    }

    func normal(_ elevation: Look.Elevation) -> Color {
        render(color: palette.background2, at: elevation)
    }
}

public extension SurfaceProviderProtocol {
    func foregroundLight(_ elevation: Look.Elevation) -> Color {
        render(color: palette.label, at: elevation)
    }

    func foregroundDark(_ elevation: Look.Elevation) -> Color {
        render(color: palette.label2, at: elevation)
    }
}

public extension SurfaceProviderProtocol {
    func foregroundCanvas(_ elevation: Look.Elevation) -> Color {
        render(color: canvas, at: elevation)
            .uiColor()
            .contrast(
                bright: foregroundLight.uiColor(),
                dark: foregroundDark.uiColor()
            ).uiColor
    }

    func foregroundNormal(_ elevation: Look.Elevation) -> Color {
        render(color: normal, at: elevation)
            .uiColor()
            .contrast(
                bright: foregroundLight.uiColor(),
                dark: foregroundDark.uiColor()
            ).uiColor
    }

    func foregroundAccent(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color {
        let color = HueColor(color: render(color: accent, at: elevation).uiColor())
        let tint = HueColor(color: active(.normal, prio: prio).uiColor())
        return HueColor(hue: tint.hue,
                        saturation: max(color.saturation, tint.saturation),
                        brightness: max(color.brightness, tint.brightness))
            .toUIColor().uiColor
    }

    func foregroundActive(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color {
        render(color: active(.normal, prio: prio), at: elevation)
            .uiColor()
            .contrast(
                bright: foregroundLight.uiColor(),
                dark: foregroundDark.uiColor()
            ).uiColor
    }

    func foregroundContrast(_ elevation: Look.Elevation, prio: Look.Priority?) -> Color {
        render(color: contrast(.normal, prio: prio), at: elevation)
    }
}

extension Look {
    public enum Scheme: String, Codable, Hashable {
        case light
        case dark

        public var colorScheme: ColorScheme {
            self == .light ? .light : .dark
        }
    }
}
