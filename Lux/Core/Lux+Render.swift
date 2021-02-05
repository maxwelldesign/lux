//
//  Styling+Lux+FX.swift
//  Styling
//
//  Created by mark maxwell on 2/12/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI

public extension Lux {
    struct Render: LuxRenderAPI {
        public typealias LuxRenderAPIType = Render
        public var lux: Lux
    }
}

extension Lux.Render: LuxControlFlowAPI {
    public typealias LuxControlFlowAPIType = Lux.Render
}

public extension Lux.Render {
    @discardableResult
    func mirrorBlock(_ block: @escaping Lux.LuxRenderBlock) -> Lux.Render {
        backgroundBlock(block)
    }

    @discardableResult
    func backgroundBlock(_ block: @escaping Lux.LuxRenderBlock) -> Lux.Render {
        viewMutation {
            $0.background(block(self)).anyView()
        }
    }

    @discardableResult
    func overlayBlock(_: Trait = Trait(), block: @escaping Lux.LuxRenderBlock) -> Lux.Render {
        viewMutation {
            $0.overlay(block(self)).anyView()
        }
    }
}

// MARK: LuxCompositionAPI

extension Lux.Render: LuxCompositionAPI {
    @discardableResult
    public func look(refreshId: String) -> Lux.Render {
        lux.look(refreshId: refreshId)
        return self
    }

    @discardableResult
    public func trait(_ trait: Trait) -> Lux.Render {
        lux.trait(trait)
        return self
    }

    @discardableResult
    public func _tweak(as tweak: Lux.Tweak) -> Lux.Render {
        lux._tweak(as: tweak)
        return self
    }

    @discardableResult
    public func _tweakBlock(_ traitMutator: (Trait) -> Trait) -> Lux.Render {
        lux._tweakBlock(traitMutator)
        return self
    }

    @discardableResult
    public func _renderBlock(_ renderBlock: (Lux.Render) -> Any?) -> Lux.Render {
        lux._renderBlock(renderBlock)
        return self
    }

    @discardableResult
    public func _feature(as feature: Lux.Feature) -> Lux.Render {
        lux._feature(as: feature)
        return self
    }

    @discardableResult
    public func _style(as effect: Lux.Style) -> Lux.Render {
        lux._style(as: effect)
        return self
    }
}
