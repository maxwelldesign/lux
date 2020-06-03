//
//  File.swift
//
//
//  Created by mark maxwell on 4/19/20.
//

import SwiftUI

extension Trait: LuxTraitAPI {
    // MARK: CORE API

    @discardableResult
    public func _tweak(as tweak: Lux.Tweak) -> Trait {
        tweak.apply(to: self)
    }

    public func tweak(_ tweaks: Lux.Tweak...) -> Trait {
        var result = self
        _ = tweaks.forEach { result = result._tweak(as: $0) }
        return result
    }

    // MARK: EXTERNAL PREFERENCES

    public func preferred(color: Color?) -> Trait {
        var mutation = self
//        mutation.surface = .active
        mutation.colorOverride = color
        return mutation
    }

    public func preferred(font: Font) -> Trait {
        var mutation = self
        mutation.fontOverride = font
        return mutation
    }

    public func preferred(surface: Look.Surface) -> Trait {
        var mutation = self
        mutation.surface = surface
        return mutation
    }

    public func preferred(layout: Look.Layout) -> Trait {
        var mutation = self
        mutation.layout = layout
        return mutation
    }

    // MARK: COMPLEMENT

    public func complementary(level: Int = 1) -> Trait {
        var newTrait = self
        let range = 0 ..< level
        range.forEach { _ in
            newTrait = newTrait.tweak(.complementary, .complementarySurface)
        }
        return newTrait
    }

    public func complementaryLayout(level: Int = 1) -> Trait {
        var newTrait = self
        let range = 0 ..< level
        range.forEach { _ in
            newTrait = newTrait.tweak(.complementaryLayout)
        }
        return newTrait
    }

    public func complementarySurface(level: Int = 1) -> Trait {
        var newTrait = self
        let range = 0 ..< level
        range.forEach { _ in
            newTrait = newTrait.tweak(.complementarySurface)
        }
        return newTrait
    }

    public func complementaryFont(level: Int = 1) -> Trait {
        var newTrait = self
        let range = 0 ..< level
        range.forEach { _ in
            newTrait = newTrait.tweak(.complementaryFont)
        }
        return newTrait
    }

    public func complementaryColor(level: Int = 1) -> Trait {
        var newTrait = self
        let range = 0 ..< level
        range.forEach { _ in
            newTrait = newTrait.tweak(.complementaryColor)
        }
        return newTrait
    }

    // MARK: MATH OPERATORS

    public func multiply(_ keypath: WritableKeyPath<Trait.AdjustmentValues, CGFloat>, _ value: CGFloat) -> Trait {
        var mutation = self
        mutation.multipliers[keyPath: keypath] = value
        return mutation
    }
}
