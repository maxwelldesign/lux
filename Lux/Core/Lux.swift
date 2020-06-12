//
//  Styling+Lux.swift
//  Styling
//
//  Created by mark maxwell on 2/11/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

public class Lux {
    public typealias RenderBlock = (Lux.Render) -> Any?
    public typealias EffectBuilder = (_ tweaks: [Lux.Tweak], _ features: [Lux.Feature]) -> Lux.Style
    public typealias EffectBaseBuilder = (_ features: [Lux.Feature]) -> Lux.Style
    public typealias ViewBlockClosure = (AnyView) -> AnyView

    public var _uiView: UIView?

    public var view: AnyView {
        didSet {
            guard let uiView = _uiView else { return }
            UIMirroringCoordinator.Manager.sync(uiView, view)
        }
    }

    public var trait: Trait
    public private(set) var _features: [Feature] = []
    public private(set) var _tweaks: [Tweak] = []

    public lazy var draw = Drawing(lux: self)
    public lazy var render = Render(lux: self)

    public init(_ view: AnyView, trait: Trait) {
        self.view = view
        self.trait = trait
    }

    public init(uiView: UIView, trait: Trait) {
        _uiView = uiView
        self.trait = trait
        view = EmptyView().anyView()
    }
}

public extension Lux {
    func append(tweak: Tweak) {
        _tweaks.append(tweak)
    }

    func append(feature: Feature) {
        _features.append(feature)
    }
}

public extension Lux {
    typealias LuxRenderBlock = (Lux.Render) -> AnyView

    var uiViewMirror: UIView {
        guard let mirror = UIMirroringCoordinator.Manager.getMirror(for: _uiView) else {
            assert(false, "Error: `mirrorView` not found.")
            return UIView()
        }
        return mirror.view
    }

    func uiViewMirrorRemoveFromSuperview() {
        uiViewMirror.removeFromSuperview()
    }
}

public extension Lux {
    @discardableResult
    func setView(_ view: AnyView) -> Lux {
        self.view = view
        return self
    }

    @discardableResult
    func viewBlock(_ block: ViewBlockClosure) -> Lux {
        view = block(view)
        return self
    }

    @discardableResult
    func uiViewBlock<T: UIView>(_ block: (T) -> Void) -> Lux {
        guard let uiView = _uiView as? T else {
            assert(false, "Error: `uiView` not configured. Is this a UIKit View?. Is the block casting the input uiView to the correct subtype?")
            return self
        }
        block(uiView)
        return self
    }
}

extension Lux {
    var manifest: String {
        """
        A New LUX
        We dream with a world where human values are paramount for technological development, a future awoken by the renaissance of mankind awareness through a reconquered love for Art.
        Creativity is a pathway born from the individual language of dreams to the unreachable destination of collective understanding. Through this paradoxical reflection, Art shines at the depth of stars as an eternally distant purpose.
        Computers, software development and our digital reality had been driven by industrial and economic development. In just a lifetime, a tiny bit of humanity reached an unprecedented wealth sustained through technological advancements, but also rendering the abysmal inequality that reigns in present times.
        For this reason, a world where technology serves humanity above all measure and profit, is the future where art blossoms. A future where creativity is unleashed, a step closer to our unreachable destination as the only known wardens of life and awareness.
        Crafting intelligence shall be reconsidered as an artistic endeavor. The responsibility of crafting software and artificial intelligences that overpass the computational power of any average human is a god like power that corrupts when serving a selfish purpose...
        For a future generation of code artists that wields this infinite power, a new breed of sensitive and prepared wizards that reclaim the true power of magic, for the ones that see beyond white light,  but every color from the electromagnetic spectrum, this artwork is crafted with much love for you and each of them.
        “Thoroughly conscious ignorance is the prelude to every real advance in science.” ― James Clerk Maxwell
        """
    }
}
