//
//  Look.swift
//  FlyEditor
//
//  Created by mark maxwell on 1/3/20.
//  Copyright © 2020 eonflux. All rights reserved.
//
import Combine
import SwiftUI
import UIKit

public extension Look {
    struct Meta: Codable, Hashable {
        public var creationId = UUID().uuidString
        public var publishedVersion = 0
        public var createdAt: Date? = Date()
        public var publishedAt: Date?
        public var metaId: String?
        public var meta: String?
        public var lemma: String?
        public var manifest: String?
        public var authorName: String?
        public var authorId: String?
        public var authorURL: String?
        public var coverURL: String?
        public var assetURL: String?
        public var webURL: String?
        public var shortURL: String?
        public var qrURL: String?
    }
}

public extension Look {
    struct Data {
        public var name: String = "Maxwell"
        public var meta = Meta()
        public var preferredScheme: Look.Scheme?
        public var defaultLayout: Layout = .body
        public var defaultSurface: Surface = .normal
        public var defaultFontMix: FontMix = .byPriority
        public var defaultElevation: Elevation = .normal

        public var specLight = Specification(color: PaletteScheme.Light)
        public var specDark = Specification(color: PaletteScheme.Dark)
    }
}

open class Look: Codable, ObservableObject {
    @Published public var data = Data()

    private let queue = DispatchQueue(label: "com.maxwelldesign.lux.look.\(UUID().uuidString)")

    private var hashSalt = UUID().uuidString

    public enum CodingKeys: String, CodingKey {
        case meta
        case name
        case effectDark
        case effectLight
        case preferredScheme
        case preferredLayout
        case preferredSurface
    }

    public init() {
        resetDefaults()
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        meta = try container.decode(Look.Meta.self, forKey: .meta)
        name = try container.decode(String.self, forKey: .name)
        specDark = try container.decode(Specification.self, forKey: .effectDark)
        specLight = try container.decode(Specification.self, forKey: .effectLight)
        preferredScheme = try container.decode(Look.Scheme?.self, forKey: .preferredScheme)
        defaultSurface = try container.decode(Look.Surface.self, forKey: .preferredSurface)

        let preferredLayoutRaw = try container.decode(String.self, forKey: .preferredLayout)
        defaultLayout = Look.Layout(rawValue: preferredLayoutRaw)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(meta, forKey: .meta)
        try container.encode(specDark, forKey: .effectDark)
        try container.encode(name, forKey: .name)
        try container.encode(specLight, forKey: .effectLight)
        try container.encode(preferredScheme, forKey: .preferredScheme)
        try container.encode(defaultLayout.rawValue, forKey: .preferredLayout)
        try container.encode(defaultSurface, forKey: .preferredSurface)
    }
}

extension Look: Hashable, Equatable {
    public static func == (lhs: Look, rhs: Look) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(preferredScheme)
        hasher.combine(defaultLayout)
        hasher.combine(defaultSurface)
        hasher.combine(specLight)
        hasher.combine(specDark)
        hasher.combine(hashSalt)
        hasher.combine(meta)
    }
}

extension Look: SpecificationProtocol {}
public extension Look {
    var shadow: EffectValue {
        get {
            spec.shadow
        }
        set {
            spec.shadow = newValue
        }
    }

    var font: Look.Fonts {
        get {
            spec.font
        }
        set {
            spec.font = newValue
        }
    }

    var cornerRadius: EffectValue {
        get {
            spec.cornerRadius
        }
        set {
            spec.cornerRadius = newValue
        }
    }

    var padding: EffectValue {
        get {
            spec.padding
        }
        set {
            spec.padding = newValue
        }
    }

    var color: PaletteScheme {
        get {
            spec.color
        }
        set {
            spec.color = newValue
        }
    }

    var surface: SurfaceProvider {
        spec.surface
    }

    var elevation: EffectValue {
        get {
            spec.elevation
        }
        set {
            spec.elevation = newValue
        }
    }

    var tint: EffectValue {
        get {
            spec.tint
        }
        set {
            spec.tint = newValue
        }
    }

    var texture: Look.Texture {
        get {
            spec.texture
        }
        set {
            spec.texture = newValue
        }
    }

    var fill: EffectValue {
        get {
            spec.fill
        }
        set {
            spec.fill = newValue
        }
    }
}

public extension Look {
    var systemColorScheme: Look.Scheme {
        UIApplication.shared.windows.first?.traitCollection.userInterfaceStyle == .light ? .light : .dark
    }

    var scheme: Look.Scheme {
        preferredScheme ?? systemColorScheme
    }

    var colorScheme: ColorScheme {
        scheme == .light ? .light : .dark
    }
}

public extension Look {
    func isActive(colorPriority prio: Look.Priority, scheme: Look.Scheme = .light) -> Bool {
        scheme == scheme && color.priority == prio
    }

    func isActive(fontPriority prio: Look.Priority, scheme: Look.Scheme = .light) -> Bool {
        scheme == scheme && font.priority == prio
    }
}

public extension Look {
    func saltHash() {
        hashSalt = UUID().uuidString
    }
}

public extension Look {
    func instance() -> Look {
        let look = clone()
        look.meta.createdAt = Date()
        look.meta.creationId = UUID().uuidString
        return look
    }

    func clone() -> Look {
        let string = asJSONString()
        guard let clone: Look = try? Codec.object(fromJSON: string) else {
            assert(false, "error")
            return Look()
        }
        return clone
    }
}

public extension Look {
    func toggleScheme() {
        preferredScheme = scheme == .light ? .dark : .light
    }

    func preferredSchemeFromSystem() {
        preferredScheme = nil
    }
}

public extension Look {
    func resetDefaults() {
        defaultLayout = .body
        defaultSurface = .normal
        defaultFontMix = .byPriority
        defaultElevation = .normal
    }
}

public extension Look {
    func increasePublishedVersion() {
        meta.publishedVersion += 1
    }
}

public extension Look {
    var trait: Trait {
        get {
            Trait(
                layout: defaultLayout,
                surface: defaultSurface,
                fontPriority: font.priority,
                colorPriority: color.priority,
                fontMix: defaultFontMix
            )
        }
        set {
            defaultLayout = newValue.layout
            defaultSurface = newValue.surface
            defaultFontMix = newValue.preferredFontMix
            font.preferred = newValue.fontPriority
            color.preferred = newValue.colorPriority
        }
    }
}

public extension Look {
    var spec: Specification {
        get {
            queue.sync { scheme == .light ? specLight : specDark }
        }
        set {
            queue.sync {
                switch colorScheme {
                case .light:
                    specLight = newValue
                default:
                    specDark = newValue
                }
            }
        }
    }

    var preferredScheme: Look.Scheme? {
        get {
            data.preferredScheme
        }
        set {
            data.preferredScheme = newValue
        }
    }

    var defaultLayout: Look.Layout {
        get {
            data.defaultLayout
        }
        set {
            data.defaultLayout = newValue
        }
    }

    var defaultSurface: Look.Surface {
        get {
            data.defaultSurface
        }
        set {
            data.defaultSurface = newValue
        }
    }

    var defaultFontMix: Look.FontMix {
        get {
            data.defaultFontMix
        }
        set {
            data.defaultFontMix = newValue
        }
    }

    var defaultElevation: Look.Elevation {
        get {
            data.defaultElevation
        }
        set {
            data.defaultElevation = newValue
        }
    }

    var specLight: Specification {
        get {
            data.specLight
        }
        set {
            data.specLight = newValue
        }
    }

    var specDark: Specification {
        get {
            data.specDark
        }
        set {
            data.specDark = newValue
        }
    }

    var name: String {
        get {
            data.name
        }
        set {
            data.name = newValue
        }
    }

    var meta: Meta {
        get {
            data.meta
        }
        set {
            data.meta = newValue
        }
    }
}
