//
//  Look+PaletteScheme.swift
//  StylingLook
//
//  Created by mark maxwell on 1/9/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI

protocol LookPriority {
    var preferred: Look.Priority? { get set }
    var priority: Look.Priority { get }
}

public extension Look {
    struct PaletteScheme: PaletteProtocol, Codable, LookPriority, Hashable {
        public var preferred: Look.Priority?

        public var primary = UIColor(hex: "#39277FFF")!
        public var secondary = UIColor(hex: "#272F96FF")!
        public var tertiary = UIColor(hex: "#72248CFF")!

        public var label = UIColor.label
        public var label2 = UIColor.secondaryLabel
        public var label3 = UIColor.tertiaryLabel
        public var label4 = UIColor.quaternaryLabel

        public var fill = UIColor.systemFill
        public var fill2 = UIColor.secondarySystemFill
        public var fill3 = UIColor.tertiarySystemFill
        public var fill4 = UIColor.quaternarySystemFill

        public var shadow = UIColor.quaternarySystemFill

        public var tint = UIColor.systemFill
        public var tint2 = UIColor.secondarySystemFill
        public var tint3 = UIColor.tertiarySystemFill

        public var background = UIColor.systemBackground
        public var background2 = UIColor.secondarySystemBackground
        public var background3 = UIColor.tertiarySystemBackground

        public var group = UIColor.systemGroupedBackground
        public var group2 = UIColor.secondarySystemGroupedBackground
        public var group3 = UIColor.tertiarySystemGroupedBackground

        public enum CodingKeys: String, CodingKey {
            case preferred
            case primary, secondary, tertiary
            case label
            case label2
            case label3
            case label4

            case fill
            case fill2
            case fill3
            case fill4

            case shadow

            case tint
            case tint2
            case tint3

            case background
            case background2
            case background3

            case group
            case group2
            case group3
        }

        public init() {}

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            preferred = try container.decode(Look.Priority?.self, forKey: .preferred)

            primary = try container.decode(CodableColor.self, forKey: .primary).uiColor
            secondary = try container.decode(CodableColor.self, forKey: .secondary).uiColor
            tertiary = try container.decode(CodableColor.self, forKey: .tertiary).uiColor

            label = try container.decode(CodableColor.self, forKey: .label).uiColor
            label2 = try container.decode(CodableColor.self, forKey: .label2).uiColor
            label3 = try container.decode(CodableColor.self, forKey: .label3).uiColor
            label4 = try container.decode(CodableColor.self, forKey: .label4).uiColor

            fill = try container.decode(CodableColor.self, forKey: .fill).uiColor
            fill2 = try container.decode(CodableColor.self, forKey: .fill2).uiColor
            fill3 = try container.decode(CodableColor.self, forKey: .fill3).uiColor
            fill4 = try container.decode(CodableColor.self, forKey: .fill4).uiColor

            shadow = try container.decode(CodableColor.self, forKey: .shadow).uiColor

            tint = try container.decode(CodableColor.self, forKey: .tint).uiColor
            tint2 = try container.decode(CodableColor.self, forKey: .tint2).uiColor
            tint3 = try container.decode(CodableColor.self, forKey: .tint3).uiColor

            background = try container.decode(CodableColor.self, forKey: .background).uiColor
            background2 = try container.decode(CodableColor.self, forKey: .background2).uiColor
            background3 = try container.decode(CodableColor.self, forKey: .background3).uiColor

            group = try container.decode(CodableColor.self, forKey: .group).uiColor
            group2 = try container.decode(CodableColor.self, forKey: .group2).uiColor
            group3 = try container.decode(CodableColor.self, forKey: .group3).uiColor
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(preferred, forKey: .preferred)

            try container.encode(CodableColor(primary), forKey: .primary)
            try container.encode(CodableColor(secondary), forKey: .secondary)
            try container.encode(CodableColor(tertiary), forKey: .tertiary)

            try container.encode(CodableColor(label), forKey: .label)
            try container.encode(CodableColor(label2), forKey: .label2)
            try container.encode(CodableColor(label3), forKey: .label3)
            try container.encode(CodableColor(label4), forKey: .label4)

            try container.encode(CodableColor(fill), forKey: .fill)
            try container.encode(CodableColor(fill2), forKey: .fill2)
            try container.encode(CodableColor(fill3), forKey: .fill3)
            try container.encode(CodableColor(fill4), forKey: .fill4)

            try container.encode(CodableColor(shadow), forKey: .shadow)

            try container.encode(CodableColor(tint), forKey: .tint)
            try container.encode(CodableColor(tint2), forKey: .tint2)
            try container.encode(CodableColor(tint3), forKey: .tint3)

            try container.encode(CodableColor(background), forKey: .background)
            try container.encode(CodableColor(background2), forKey: .background2)
            try container.encode(CodableColor(background3), forKey: .background3)

            try container.encode(CodableColor(group), forKey: .group)
            try container.encode(CodableColor(group2), forKey: .group2)
            try container.encode(CodableColor(group3), forKey: .group3)
        }

        public static func semantic(light: UIColor, dark: UIColor) -> UIColor {
            UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return light
                case .dark:
                    return dark
                case .unspecified:
                    return light
                default:
                    return light
                }
            }
        }

        public static func semantic(light: Color, dark: Color) -> Color {
            let a = light.uiColor()
            let b = dark.uiColor()

            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return a
                case .dark:
                    return b
                case .unspecified:
                    return a
                default:
                    return a
                }
            }.paint
        }

        public static func select(_ scheme: Look.Scheme, light: UIColor, dark: UIColor) -> UIColor {
            if scheme == .dark {
                return dark
            }
            return light
        }

        public static func select(_ scheme: Look.Scheme, light: Color, dark: Color) -> Color {
            if scheme == .dark {
                return dark
            }
            return light
        }
    }
}

public extension Look.PaletteScheme {
    var priority: Look.Priority {
        preferred ?? .primary
    }

    var specName: String {
        switch priority {
        case .primary:
            return "1"
        case .secondary:
            return "2"
        case .tertiary:
            return "3"
        }
    }
}

extension Look.PaletteScheme {
    static var Dark: Look.PaletteScheme {
        var result = Look.PaletteScheme()
        result.primary = UIColor(hex: "#39277FFF")!
        result.secondary = UIColor(hex: "#5545CCFF")!
        result.tertiary = UIColor(hex: "#8F25B3FF")!

        result.label = UIColor(white: 0.9, alpha: 0.85)
        result.label2 = UIColor(white: 0.1, alpha: 0.85)
        result.label3 = UIColor.label.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.label4 = UIColor.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark))

        // used by tint?
        result.fill = UIColor(white: 1.0, alpha: 0.5)
        result.fill2 = UIColor.secondarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.fill3 = UIColor.tertiarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.fill4 = UIColor.quaternarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .dark))

        result.shadow = UIColor(white: 1.0, alpha: 0.9)

        // used by tint?
        result.tint = UIColor(white: 0.6, alpha: 0.5)
        result.tint2 = UIColor(white: 0.6, alpha: 0.0)
        result.tint3 = UIColor(white: 0.6, alpha: 0.0)

        result.background = UIColor.systemBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.background2 = UIColor.secondarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.background3 = UIColor.tertiarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))

        result.group = UIColor.systemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.group2 = UIColor.secondarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))
        result.group3 = UIColor.tertiarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark))

        return result
    }

    static var Light: Look.PaletteScheme {
        var result = Look.PaletteScheme()
        result.primary = UIColor(hex: "#8F25B3FF")!
        result.secondary = UIColor(hex: "#5545CCFF")!
        result.tertiary = UIColor(hex: "#39277FFF")!

        result.label = UIColor(white: 0.9, alpha: 0.85)
        result.label2 = UIColor(white: 0.1, alpha: 0.85)
        result.label3 = UIColor.label.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.label4 = UIColor.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .light))

        result.fill = UIColor(white: 1.0, alpha: 0.5)
        result.fill2 = UIColor.secondarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.fill3 = UIColor.tertiarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.fill4 = UIColor.quaternarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .light))

        result.shadow = UIColor(white: 0.0, alpha: 1.0)
        result.tint = UIColor(white: 1.0, alpha: 0.5)
        result.tint2 = UIColor(white: 1.0, alpha: 0.0)
        result.tint3 = UIColor(white: 1.0, alpha: 0.0)

        result.background = UIColor.systemBackground.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.background2 = UIColor.secondarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.background3 = UIColor.tertiarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .light))

        result.group = UIColor.systemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.group2 = UIColor.secondarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .light))
        result.group3 = UIColor.tertiarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .light))

        return result
    }
}
