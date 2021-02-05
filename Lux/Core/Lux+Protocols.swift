//
//  Styling+Lux+Protocols.swift
//  StylingLook
//
//  Created by mark maxwell on 2/12/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI

// MARK: - APIS

public protocol LuxCoreAPI {
    var trait: Trait { get }
    var view: AnyView { get }
    var spec: SpecificationProtocol { get }
    var draw: Lux.Drawing { get }
    var render: Lux.Render { get }
}

public protocol LuxRenderAPI: LuxCoreAPI {
    associatedtype LuxRenderAPIType: LuxRenderAPI
    var lux: Lux { get }
    func viewMutation(_ block: ViewMutator) -> LuxRenderAPIType
    func traitMutation(_ block: TraitMutator) -> LuxRenderAPIType
}

public protocol LuxControlFlowAPI: LuxRenderAPI {
    associatedtype LuxControlFlowAPIType: LuxControlFlowAPI
    func `if`(_ condition: Bool, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType
    func unless(_ condition: Bool, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType
    func `if`(userInterfaceIdiom: UIUserInterfaceIdiom, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType
    func unless(userInterfaceIdiom: UIUserInterfaceIdiom, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType
}

public protocol LuxTraitAPI {
    func _tweak(as tweak: Lux.Tweak) -> Trait
    func tweak(_ tweaks: Lux.Tweak...) -> Trait

    func preferred(color: Color?) -> Trait
    func preferred(font: Font) -> Trait
    func preferred(surface: Look.Surface) -> Trait
    func preferred(layout: Look.Layout) -> Trait

    func complementary(level: Int) -> Trait
    func complementaryLayout(level: Int) -> Trait
    func complementarySurface(level: Int) -> Trait
    func complementaryFont(level: Int) -> Trait
    func complementaryColor(level: Int) -> Trait

    func multiply(_ keypath: WritableKeyPath<Trait.AdjustmentValues, CGFloat>, _ value: CGFloat) -> Trait
}

public protocol LuxCompositionAPI: LuxCoreAPI {
    associatedtype LuxCompositionAPIType: LuxCompositionAPI
    func trait(_ trait: Trait) -> LuxCompositionAPIType

    func _tweakBlock(_ traitMutator: LuxRenderAPI.TraitMutator) -> LuxCompositionAPIType
    func _renderBlock(_ renderBlock: Lux.RenderBlock) -> LuxCompositionAPIType

    func _tweak(as tweak: Lux.Tweak) -> LuxCompositionAPIType
    func _feature(as feature: Lux.Feature) -> LuxCompositionAPIType
    func _style(as effect: Lux.Style) -> LuxCompositionAPIType

    // Internally implemented
    func tweak(_ tweaks: Lux.Tweak...) -> LuxCompositionAPIType
    func feature(_ features: Lux.Feature...) -> LuxCompositionAPIType
    func style(_ effects: Lux.Style...) -> LuxCompositionAPIType

    func look(refreshId: String) -> LuxCompositionAPIType
}

// MARK: - LuxRenderAPI

public extension LuxRenderAPI {
    var view: AnyView {
        lux.view
    }

    var trait: Trait {
        lux.trait
    }

    var spec: SpecificationProtocol {
        lux.spec
    }

    var draw: Lux.Drawing {
        lux.draw
    }

    var render: Lux.Render {
        lux.render
    }
}

public extension LuxRenderAPI {
    typealias ViewMutator = (AnyView) -> AnyView
    typealias TraitMutator = (Trait) -> Trait

    @discardableResult
    func viewMutation(_ block: ViewMutator) -> LuxRenderAPIType {
        // TODO: sync with quue and locks
        let currentView = lux.view
        lux.view = block(currentView)
        return self as! Self.LuxRenderAPIType
    }

    @discardableResult
    func traitMutation(_ block: TraitMutator) -> LuxRenderAPIType {
        // TODO: sync with quue and locks
        let currentTrait = lux.trait
        lux.trait = block(currentTrait)
        return self as! Self.LuxRenderAPIType
    }
}

// MARK: LuxCompositionAPI

public extension LuxCompositionAPI {
    @discardableResult
    func tweak(_ tweaks: Lux.Tweak...) -> LuxCompositionAPIType {
        _ = tweaks.forEach { _ = _tweak(as: $0) }
        return self as! LuxCompositionAPIType
    }

    @discardableResult
    func style(_ effects: Lux.Style...) -> LuxCompositionAPIType {
        _ = effects.forEach { _ = _style(as: $0) }
        return self as! LuxCompositionAPIType
    }

    @discardableResult
    func feature(_ features: Lux.Feature...) -> LuxCompositionAPIType {
        _ = features.forEach { _ = _feature(as: $0) }
        return self as! LuxCompositionAPIType
    }
}

// MARK: LuxControlFlowAPI

public extension LuxControlFlowAPI {
    @discardableResult
    func `if`(_ condition: Bool, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType {
        if condition {
            if let result = block(self as! LuxControlFlowAPIType) as? AnyView {
                lux.view = result
            }
        }
        return self as! LuxControlFlowAPIType
    }

    @discardableResult
    func unless(_ condition: Bool, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType {
        if condition == false {
            if let result = block(self as! LuxControlFlowAPIType) as? AnyView {
                lux.view = result
            }
        }
        return self as! LuxControlFlowAPIType
    }

    @discardableResult
    func `if`(userInterfaceIdiom: UIUserInterfaceIdiom, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType {
        if UIDevice.current.userInterfaceIdiom == userInterfaceIdiom {
            if let result = block(self as! LuxControlFlowAPIType) as? AnyView {
                lux.view = result
            }
        }
        return self as! LuxControlFlowAPIType
    }

    @discardableResult
    func unless(userInterfaceIdiom: UIUserInterfaceIdiom, _ block: (LuxControlFlowAPIType) -> Any?) -> LuxControlFlowAPIType {
        if UIDevice.current.userInterfaceIdiom != userInterfaceIdiom {
            if let result = block(self as! LuxControlFlowAPIType) as? AnyView {
                lux.view = result
            }
        }
        return self as! LuxControlFlowAPIType
    }
}
