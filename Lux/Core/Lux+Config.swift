//
//  File.swift
//
//
//  Created by mark maxwell on 4/19/20.
//

import SwiftUI

extension Lux: LuxControlFlowAPI {
    public var lux: Lux {
        self
    }

    public typealias LuxControlFlowAPIType = Lux
    public typealias LuxRenderAPIType = Lux
}

public extension Lux {
    var spec: SpecificationProtocol {
        trait.spec
    }
}

extension Lux: LuxCompositionAPI {
    @discardableResult
    public func look(refreshId: String) -> Lux {
        viewMutation {
            $0.id("\(refreshId)\(Look.current.hashValue)").anyView()
        }
    }

    typealias LuxProviderType = Lux

    @discardableResult
    public func trait(_ trait: Trait) -> Lux {
        render.traitMutation { _ in
            trait
        }
        return self
    }

    @discardableResult
    public func _tweak(as tweak: Lux.Tweak) -> Lux {
        append(tweak: tweak)
        tweak.render(to: self)
        return self
    }

    @discardableResult
    public func _feature(as feature: Lux.Feature) -> Lux {
        append(feature: feature)
        feature.render(to: self)
        return self
    }

    @discardableResult
    public func _tweakBlock(_ traitMutator: LuxRenderAPI.TraitMutator) -> Lux {
        render.traitMutation {
            traitMutator($0)
        }
        return self
    }

    @discardableResult
    public func _renderBlock(_ renderBlock: Lux.RenderBlock) -> Lux {
        if let view = renderBlock(render) as? AnyView {
            self.view = view
        }
        return self
    }
}

public extension Lux {
    @discardableResult
    func _style(as effect: Lux.Style) -> Lux {
        effect.render(to: self)
        return self
    }

    @discardableResult
    func style(_ effects: Lux.Style...) -> Lux {
        effects.forEach { _style(as: $0) }
        return self
    }
}
