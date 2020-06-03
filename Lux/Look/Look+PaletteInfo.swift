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

extension Look {
    public struct PaletteScheme: PaletteProtocol, Codable, LookPriority, Hashable {
        public var preferred: Look.Priority?

        public var primary = Color(hex: "39277F")
        public var secondary = Color(hex: "272F96")
        public var tertiary = Color(hex: "72248C")

        public var label = UIColor.label.uiColor
        public var label2 = UIColor.secondaryLabel.uiColor
        public var label3 = UIColor.tertiaryLabel.uiColor
        public var label4 = UIColor.quaternaryLabel.uiColor

        public var fill = UIColor.systemFill.uiColor
        public var fill2 = UIColor.secondarySystemFill.uiColor
        public var fill3 = UIColor.tertiarySystemFill.uiColor
        public var fill4 = UIColor.quaternarySystemFill.uiColor

        public var shadow = UIColor.quaternarySystemFill.uiColor

        public var tint = UIColor.systemFill.uiColor
        public var tint2 = UIColor.secondarySystemFill.uiColor
        public var tint3 = UIColor.tertiarySystemFill.uiColor

        public var background = UIColor.systemBackground.uiColor
        public var background2 = UIColor.secondarySystemBackground.uiColor
        public var background3 = UIColor.tertiarySystemBackground.uiColor

        public var group = UIColor.systemGroupedBackground.uiColor
        public var group2 = UIColor.secondarySystemGroupedBackground.uiColor
        public var group3 = UIColor.tertiarySystemGroupedBackground.uiColor

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

            primary = try container.decode(CodableColor.self, forKey: .primary).uiColor.uiColor
            secondary = try container.decode(CodableColor.self, forKey: .secondary).uiColor.uiColor
            tertiary = try container.decode(CodableColor.self, forKey: .tertiary).uiColor.uiColor

            label = try container.decode(CodableColor.self, forKey: .label).uiColor.uiColor
            label2 = try container.decode(CodableColor.self, forKey: .label2).uiColor.uiColor
            label3 = try container.decode(CodableColor.self, forKey: .label3).uiColor.uiColor
            label4 = try container.decode(CodableColor.self, forKey: .label4).uiColor.uiColor

            fill = try container.decode(CodableColor.self, forKey: .fill).uiColor.uiColor
            fill2 = try container.decode(CodableColor.self, forKey: .fill2).uiColor.uiColor
            fill3 = try container.decode(CodableColor.self, forKey: .fill3).uiColor.uiColor
            fill4 = try container.decode(CodableColor.self, forKey: .fill4).uiColor.uiColor

            shadow = try container.decode(CodableColor.self, forKey: .shadow).uiColor.uiColor

            tint = try container.decode(CodableColor.self, forKey: .tint).uiColor.uiColor
            tint2 = try container.decode(CodableColor.self, forKey: .tint2).uiColor.uiColor
            tint3 = try container.decode(CodableColor.self, forKey: .tint3).uiColor.uiColor

            background = try container.decode(CodableColor.self, forKey: .background).uiColor.uiColor
            background2 = try container.decode(CodableColor.self, forKey: .background2).uiColor.uiColor
            background3 = try container.decode(CodableColor.self, forKey: .background3).uiColor.uiColor

            group = try container.decode(CodableColor.self, forKey: .group).uiColor.uiColor
            group2 = try container.decode(CodableColor.self, forKey: .group2).uiColor.uiColor
            group3 = try container.decode(CodableColor.self, forKey: .group3).uiColor.uiColor
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
            }.uiColor
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
        result.primary = Color(hex: "39277F")
        result.secondary = Color(hex: "5545CC")
        result.tertiary = Color(hex: "8F25B3")

        result.label = Color(white: 0.9, opacity: 0.85)
        result.label2 = Color(white: 0.1, opacity: 0.85)
        result.label3 = UIColor.label.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.label4 = UIColor.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor

        // used by tint?
        result.fill = Color(white: 1.0, opacity: 0.5)
        result.fill2 = UIColor.secondarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.fill3 = UIColor.tertiarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.fill4 = UIColor.quaternarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor

        result.shadow = Color(white: 1.0, opacity: 0.9)

        // used by tint?
        result.tint = Color(white: 0.6, opacity: 0.5)
        result.tint2 = Color(white: 0.6, opacity: 0.0)
        result.tint3 = Color(white: 0.6, opacity: 0.0)

        result.background = UIColor.systemBackground.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.background2 = UIColor.secondarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.background3 = UIColor.tertiarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor

        result.group = UIColor.systemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.group2 = UIColor.secondarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor
        result.group3 = UIColor.tertiarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .dark)).uiColor

        return result
    }

    static var Light: Look.PaletteScheme {
        var result = Look.PaletteScheme()
        result.primary = Color(hex: "8F25B3")
        result.secondary = Color(hex: "5545CC")
        result.tertiary = Color(hex: "39277F")

        result.label = Color(white: 0.9, opacity: 0.85)
        result.label2 = Color(white: 0.1, opacity: 0.85)
        result.label3 = UIColor.label.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.label4 = UIColor.secondaryLabel.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor

        result.fill = Color(white: 1.0, opacity: 0.5)
        result.fill2 = UIColor.secondarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.fill3 = UIColor.tertiarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.fill4 = UIColor.quaternarySystemFill.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor

        result.shadow = Color(white: 0.0, opacity: 1.0)
        result.tint = Color(white: 1.0, opacity: 0.5)
        result.tint2 = Color(white: 1.0, opacity: 0.0)
        result.tint3 = Color(white: 1.0, opacity: 0.0)

        result.background = UIColor.systemBackground.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.background2 = UIColor.secondarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.background3 = UIColor.tertiarySystemBackground.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor

        result.group = UIColor.systemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.group2 = UIColor.secondarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor
        result.group3 = UIColor.tertiarySystemGroupedBackground.resolvedColor(with: .init(userInterfaceStyle: .light)).uiColor

        return result
    }
}
