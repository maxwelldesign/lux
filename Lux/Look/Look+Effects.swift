//
//  Look+Mags.swift
//  Styling
//
//  Created by mark maxwell on 1/5/20.
//  Copyright © 2020 eonflux. All rights reserved.
//
import SwiftUI

public extension Look {
    internal static let limits = Limits()

    struct Limits: Codable, Hashable {
        var hairline: CGFloat = 1.0
        var minGutter: CGFloat = 2.0
        var maxGutter: CGFloat = 64.0

        var minOverflow: CGFloat = 0.0
        var maxOverflow: CGFloat = 44.0

        var minElevation: CGFloat = -0.5
        var maxElevation: CGFloat = 0.5
    }

    struct Specification: SpecificationProtocol, Codable, Hashable {
        public var texture = Look.Texture()

        public static func == (lhs: Look.Specification, rhs: Look.Specification) -> Bool {
            lhs.hashValue == rhs.hashValue
        }

        public var color = PaletteScheme()
        public var font = Fonts()
        public var tint = EffectValue(
            name: "Tint",
            valueFormat: "%.2f",
            current: 0.0,
            flow: 0.5,
            mix: 1.0,
            min: 0.0,
            max: 1.0,
            step: 0.01
        )

        public var fill = EffectValue(
            name: "Active Fill",
            valueFormat: "%.2f",
            current: 0.0,
            flow: 0.0,
            mix: 1.0,
            min: 0.0,
            max: 1.0,
            step: 0.01
        )

        public var elevation = EffectValue(
            name: "Elevation",
            valueFormat: "%.2f",
            current: CGFloat(StylingPhi * 0.1),
            flow: 0.0,
            mix: 1.0,
            min: Look.limits.minElevation,
            max: Look.limits.maxElevation,
            step: 0.01
        )
        public var cornerRadius = EffectValue(
            name: "Roundness",
            valueFormat: "%.0f",
            current: 8,
            flow: 0.0,
            mix: 1,
            min: 2,
            max: 18,
            step: 2.0
        )
        public var padding = EffectValue(
            name: "Padding",
            valueFormat: "%.0f",
            current: 16,
            flow: 0.0,
            mix: 1.0,
            min: 8,
            max: 18,
            step: 1
        )
        public var shadow = EffectValue(
            name: "Shadows",
            valueFormat: "%.0f",
            current: CGFloat(StylingPhi * 8),
            flow: 0.5,
            mix: 0.25,
            min: Look.limits.minOverflow,
            max: Look.limits.maxOverflow,
            step: 0.02
        )
    }

    struct Texture: Codable, Hashable {
        public enum Style: String, Codable, Hashable {
            case linearGradient
            case radialGradient
        }

        public var style: Style = .linearGradient
        public var start: UnitPoint = .topLeading
        public var end: UnitPoint = .bottomTrailing

        public enum CodingKeys: String, CodingKey {
            case style
            case start
            case end
        }

        public init() {}
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            style = try container.decode(Style.self, forKey: .style)
            start = try container.decode(UnitPoint.self, forKey: .start)
            end = try container.decode(UnitPoint.self, forKey: .end)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(style, forKey: .style)
            try container.encode(start, forKey: .start)
            try container.encode(end, forKey: .end)
        }
    }
}

extension UnitPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        x = try container.decode(CGFloat.self, forKey: .x)
        y = try container.decode(CGFloat.self, forKey: .y)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

public extension Look {
    struct SurfaceProvider: SurfaceProviderProtocol {
        public var spec: Look.Specification
        public var priority: Look.Priority
        public var palette: PaletteProtocol
    }
}

public extension Look.Specification {
    var surface: Look.SurfaceProvider {
        Look.SurfaceProvider(spec: self, priority: color.priority, palette: color)
    }
}
