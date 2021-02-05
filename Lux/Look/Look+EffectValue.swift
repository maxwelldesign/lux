//
//  Look+Protocols.swift
//  Styling
//
//  Created by mark maxwell on 1/14/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import UIKit

public protocol SpecificationProtocol: Codable {
    var surface: Look.SurfaceProvider { get }
    var font: Look.Fonts { get }
    var color: Look.PaletteScheme { get }
    var tint: EffectValue { get }
    var elevation: EffectValue { get }
    var cornerRadius: EffectValue { get }
    var padding: EffectValue { get }
    var shadow: EffectValue { get }
    var fill: EffectValue { get }
    var texture: Look.Texture { get }
    var hashValue: Int { get }

    func elevationBrightness(for elevationValue: Look.Elevation) -> CGFloat
}

public protocol EffectValueProtocol {
    var current: CGFloat { get set }
    var base: CGFloat { get set }
    var flow: CGFloat { get set }
    var mix: CGFloat { get set }
    var min: CGFloat { get set }
    var max: CGFloat { get set }

    var step: CGFloat.Stride { get set }
    var range: ClosedRange<CGFloat> { get }

    var enabled: Bool { get set }
    var muted: Bool { get }
}

public extension SpecificationProtocol {
    func elevationBrightness(for elevationValue: Look.Elevation) -> CGFloat {
        let elevator = elevation.base * 0.5 * elevation.flowNormal
        let weight = elevation.base * 0.05 * elevation.flowComplement
        let value = elevationValue.value
        return elevator * value + (weight * -value)
    }
}

public extension EffectValueProtocol {
    var range: ClosedRange<CGFloat> {
        min ... max
    }

    var rangeValue: CGFloat {
        max - min
    }

    var currentRangeValue: CGFloat {
        current - min
    }

    var currentRangeScale: CGFloat {
        currentRangeValue / rangeValue
    }

    var intensity: CGFloat {
        Swift.max(0.0, Swift.min(1.0, currentRangeScale * mix))
    }
}

public struct EffectValue: EffectValueProtocol, EffectFraction, EffectSize, Codable, Hashable {
    public var name = "Effect"
    public var valueFormat = "%.2f"
    public var current: CGFloat = 0.5
    public var enabled = true
    public var muted = false
    public var flow: CGFloat = 1.0
    public var mix: CGFloat = 1.0
    public var mixEmpty: CGFloat = 0.0
    public var mixFull: CGFloat = 1.0
    public var min: CGFloat = 0.0
    public var max: CGFloat = 1.0
    public var step = CGFloat.Stride(StylingPhi * 0.1)

    public var base: CGFloat {
        get {
            currentNormal * mixNormal
        }
        set {
            currentNormal = newValue
        }
    }

    public var currentNormal: CGFloat {
        get {
            Swift.min(max, Swift.max(current, min))
        }
        set {
            current = Swift.min(max, Swift.max(newValue, min))
        }
    }

    public var flowNormalDisplay: CGFloat {
        get {
            Swift.min(1.0, Swift.max(flow, 0.0))
        }
        set {
            flow = Swift.min(1.0, Swift.max(newValue, 0.0))
        }
    }

    public var mixNormal: CGFloat {
        get {
            Swift.min(mixFull, Swift.max(mix, mixEmpty))
        }
        set {
            mix = Swift.min(mixFull, Swift.max(newValue, mixEmpty))
        }
    }

    public var mixRange: ClosedRange<CGFloat> {
        mixEmpty ... mixFull
    }

    public var mixComplement: CGFloat {
        1.0 - mixNormal
    }

    public var displayValue: String {
        String(format: valueFormat, currentNormal)
    }

    public var displayFlow: String {
        String(format: "%0.2f", flowNormalDisplay)
    }

    public var displayMix: String {
        String(format: "%0.2f", mixNormal)
    }

    public var displayName: String {
        name
    }
}

public extension EffectValue {
    var flowComplement: CGFloat {
        1.0 - flowNormal
    }

    var flowNormal: CGFloat {
        1.0 - Swift.max(0, Swift.min(flow, 1.0)) * mix
    }

    func flowTo(baseMultiplier: CGFloat = 1.0, _ value: CGFloat) -> CGFloat {
        (((base * baseMultiplier) * flowComplement) + value * flowNormal)
    }
}

// MARK: FRACTIONAL

public protocol EffectFraction: EffectValueProtocol {
    var full: CGFloat { get }
    var quarter3x: CGFloat { get }
    var half: CGFloat { get }
    var quarter: CGFloat { get }
    var eighth: CGFloat { get }
    var hairline2x: CGFloat { get }
    var hairline: CGFloat { get }
}

public extension EffectFraction {
    var quarter3x: CGFloat { base * 0.75 }
    var full: CGFloat { base * 1.0 }
    var half: CGFloat { base * 0.5 }
    var quarter: CGFloat { base * 0.25 }
    var eighth: CGFloat { base / 8.0 }
    var hairline2x: CGFloat { 2.0 }
    var hairline: CGFloat { 1.0 }
}

// MARK: LEVEL

public protocol EffectSize: EffectValueProtocol {
    var large: CGFloat { get }
    var medium: CGFloat { get }
    var small: CGFloat { get }
    var hairline: CGFloat { get }
}

public extension EffectSize {
    var large: CGFloat { base * 0.75 }
    var medium: CGFloat { base * 0.5 }
    var small: CGFloat { base * 0.25 }
}
