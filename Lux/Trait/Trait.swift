//
//  Styling+Types.swift
//  FlyEditor
//
//  Created by mark maxwell on 1/3/20.
//  Copyright © 2020 eonflux. All rights reserved.
//
import SwiftUI

public extension Trait {
    struct AdjustmentValues: Codable {
        public var layout: CGFloat = 1.0
        public var cornerRadius: CGFloat = 1.0
        public var padding: CGFloat = 1.0
    }

    struct AdjustmentEdges: Codable {
        public var padding: Edge.Set = .all {
            didSet {
                margin = padding
            }
        }

        public var margin: Edge.Set = .all
    }
}

public struct Trait: Codable {
    public enum Canvas: String, Codable {
        case surface
        case clear
    }

    public enum CodingKeys: String, CodingKey {
        case layout
        case surface
        case elevation
        case canvasRenderMode
        case fontPriority
        case colorPriority
        case preferredLightSpec
        case preferredDarkSpec
        case preferredFontMix
        case surfaceIgnoresSafeArea
        case multipliers
        case edges
    }

    public var preferredLightSpec: Look.Specification?
    public var preferredDarkSpec: Look.Specification?

    public var layout: Look.Layout
    public var surface: Look.Surface

    public var fontPriority: Look.Priority
    public var colorPriority: Look.Priority

    public var fontOverride: Font? // TODO: add to codabl e
    public var colorOverride: Color? // TODO: add to codable

    public var elevation: Look.Elevation
    public var canvasRenderMode: Canvas = .surface
    public var preferredFontMix: Look.FontMix
    public var preferredColorScheme: Look.Scheme?

    public var surfaceIgnoresSafeArea = true

    public var multipliers = AdjustmentValues()
    public var edges = AdjustmentEdges()

    public init(spec: Look.Specification? = nil,
                layout: Look.Layout = Look.current.defaultLayout,
                surface: Look.Surface = Look.current.defaultSurface,
                fontPriority: Look.Priority = Look.current.font.priority,
                colorPriority: Look.Priority = Look.current.color.priority,
                fontMix: Look.FontMix = Look.current.defaultFontMix,
                preferredElevation: Look.Elevation = Look.current.defaultElevation,
                preferredFont: Font? = nil,
                preferredColor: Color? = nil)
    {
        self.layout = layout
        self.surface = surface
        self.fontPriority = fontPriority
        self.colorPriority = colorPriority
        elevation = preferredElevation
        colorOverride = preferredColor
        fontOverride = preferredFont
        preferredFontMix = fontMix
        preferredLightSpec = spec
        preferredDarkSpec = spec
    }
}

extension Trait: Hashable {
    public static func == (lhs: Trait, rhs: Trait) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(layout)
        hasher.combine(surface)
        hasher.combine(canvasRenderMode)
        hasher.combine(fontPriority)
        hasher.combine(colorPriority)
        hasher.combine(preferredLightSpec?.hashValue)
        hasher.combine(preferredDarkSpec?.hashValue)
        hasher.combine(fontOverride)
        hasher.combine(colorOverride)
        hasher.combine(preferredFontMix)
        hasher.combine(preferredColorScheme)
    }
}
