//
//  File.swift
//
//
//  Created by mark maxwell on 4/19/20.
//

import SwiftUI

public extension Trait {
    var displayName: String {
        specName
    }

    var colorScheme: Look.Scheme {
        preferredColorScheme ?? Look.current.scheme
    }

    var systemSpec: SpecificationProtocol {
        switch preferredColorScheme {
        case .none:
            return Look.current.spec
        case .light:
            return Look.current.specLight
        case .dark:
            return Look.current.specDark
        }
    }

    var preferredSpec: SpecificationProtocol? {
        colorScheme == .light ? preferredLightSpec : preferredDarkSpec
    }

    var spec: SpecificationProtocol {
        preferredSpec ?? systemSpec
    }

    var specName: String {
        "\(layout.displayName) \(specNameShort)"
    }

    var specNameShort: String {
        if surface == .canvas || surface == .normal {
            return "\(surface.displayName)-\(fontPriority.specName(numeric: false))"
        }
        return "\(surface.displayName)-\(fontPriority.specName(numeric: false))\(colorPriority.specName(numeric: true))"
    }
}

public extension Trait {
    var surfaceColor: Color {
        if let preferredColor = colorOverride {
            return preferredColor
        }
        switch surface {
        case .canvas:
            switch canvasRenderMode {
            case .surface:
                return spec.surface.canvas(elevation)
            case .clear:
                return .clear
            }
        case .normal:
            return spec.surface.normal(elevation)
        case .accent:
            return spec.surface.accent(elevation, prio: colorPriority)
        case .active:
            return spec.surface.active(elevation, prio: colorPriority)
        }
    }

    var foregroundColor: Color {
        if let preferredColor = colorOverride {
            return preferredColor
        }

        let foreground: Color

        switch surface {
        case .canvas:
            foreground = spec.surface.foregroundCanvas(elevation)
        case .normal:
            foreground = spec.surface.foregroundNormal(elevation)
        case .accent:
            foreground = spec.surface.foregroundAccent(elevation, prio: colorPriority)
        case .active:
            foreground = spec.surface.foregroundActive(elevation, prio: colorPriority)
        }

        return foreground
    }

    var typography: Font {
        if let preferredFont = fontOverride {
            return preferredFont
        }

        return Font(fontType)
    }

    var fontType: UIFont {
        switch preferredFontMix {
        case .byPriority:

            let font: UIFont
            switch fontPriority {
            case .primary:
                font = spec.font.primary
            case .secondary:
                font = spec.font.secondary
            case .tertiary:
                font = spec.font.tertiary
            }
            switch layout {
            case .largeTitle:
                return font.withSize(spec.font.largeTitleSize)
            case .title, .title1, .title2, .title3:
                return font.withSize(spec.font.titleSize)
            case .headline:
                return font.withSize(spec.font.headlineSize)
            case .subheadline:
                return font.withSize(spec.font.subheadlineSize)
            case .body:
                return font.withSize(spec.font.bodySize)
            case .callout:
                return font.withSize(spec.font.calloutSize)
            case .caption, .caption1, .caption2:
                return font.withSize(spec.font.captionSize)
            case .footnote:
                return font.withSize(spec.font.footnoteSize)
            default:
                return UIFont.systemFont(ofSize: UIFont.systemFontSize)
            }
        case .mixed:
            switch layout {
            case .largeTitle:
                return spec.font.primary.withSize(spec.font.largeTitleSize)
            case .title, .title1, .title2, .title3:
                return spec.font.secondary.withSize(spec.font.titleSize)
            case .headline:
                return spec.font.tertiary.withSize(spec.font.headlineSize)
            case .subheadline:
                return spec.font.secondary.withSize(spec.font.subheadlineSize)
            case .body:
                return spec.font.primary.withSize(spec.font.bodySize)
            case .callout:
                return spec.font.secondary.withSize(spec.font.calloutSize)
            case .caption, .caption1, .caption2:
                return spec.font.tertiary.withSize(spec.font.captionSize)
            case .footnote:
                return spec.font.secondary.withSize(spec.font.footnoteSize)
            default:
                return UIFont.systemFont(ofSize: UIFont.systemFontSize)
            }
        }
    }
}

public extension Trait {
    var surfaceElevationColor: Color {
        surfaceColor.lighting(spec: spec, at: elevation)
    }
}

public extension Trait {
    var cornerRadius: CGFloat {
        spec.cornerRadius.base * multipliers.layout * multipliers.cornerRadius
    }

    var padding: CGFloat {
        spec.padding.quarter3x * multipliers.layout * multipliers.padding
    }

    var margin: CGFloat {
        spec.padding.quarter * multipliers.layout * multipliers.padding
    }

    var spacing: CGFloat {
        spec.padding.base * multipliers.layout
    }

    var separationMargin: CGFloat {
        spacing.eighth
    }

    var hairline: CGFloat {
        1
    }

    var hairline2x: CGFloat {
        2
    }
}

public extension Trait {
    var tertiaryOpacity: CGFloat {
        0.25
    }

    var secondaryOpacity: CGFloat {
        0.5
    }

    var primaryOpacity: CGFloat {
        0.75
    }
}

public extension Trait {
    var headerParagraphPadding: EdgeInsets {
        EdgeInsets(
            top: spacing.double,
            leading: spacing.half,
            bottom: spacing.half,
            trailing: spacing.half
        )
    }

    var bodyParagraphPadding: EdgeInsets {
        EdgeInsets(
            top: spacing.half,
            leading: spacing.half,
            bottom: spacing.half,
            trailing: spacing.half
        )
    }

    var captionParagraphPadding: EdgeInsets {
        EdgeInsets(
            top: spacing.quarter,
            leading: spacing.half,
            bottom: spacing.quarter,
            trailing: spacing.half
        )
    }

    var footerParagraphPadding: EdgeInsets {
        EdgeInsets(
            top: spacing.half,
            leading: spacing.half,
            bottom: spacing.double,
            trailing: spacing.half
        )
    }
}

extension Trait {
    var paragraphPadding: EdgeInsets {
        switch layout {
        case .title, .largeTitle, .callout, .title1, .title2, .title3:
            return headerParagraphPadding
        case .body, .headline, .callout:
            return bodyParagraphPadding
        case .footnote:
            return footerParagraphPadding
        case .subheadline, .caption, .caption1, .caption2:
            return captionParagraphPadding
        default:
            return bodyParagraphPadding
        }
    }
}

extension Trait {
    var shadowColor: Color {
        let maxShadow = 0.5
        let value = spec.shadow.mix.doubleValue * maxShadow
        return spec.color.shadow.withAlphaComponent(value.cgFloat).paint
    }

    var shadowRadius: CGFloat {
        spec.shadow.base // * shadowScale
    }

    var shadowOffsetY: CGFloat {
        var offsetY = spec.shadow.flow * 2.0 - 1.0
        offsetY = offsetY * -spec.padding.quarter
        return offsetY
    }
}
