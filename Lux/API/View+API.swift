//
//  Styling+View+API.swift
//  StylingLook
//
//  Created by mark maxwell on 1/9/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI

public extension UIView {
    var lux: Lux {
        let mirror = UIMirroringCoordinator.Manager.mirror(for: self)
        let lux = Lux(uiView: self, trait: Trait())
        lux.view = mirror.rootView

        return lux
    }
}

public extension View {
    var lux: Lux {
        let lux = Lux(anyView(), trait: Trait())

        return lux
    }

    func test(view: AnyView) -> AnyView {
        view.lux.feature(.accentColor, .backgroundSurfaceBase).view
    }

    func test2(view: AnyView) -> AnyView {
        view.lux
            .tweak(.captionLayout)
            .feature(.accentColor, .backgroundSurfaceBase, .bodyPadding)
            .style(.bar)
            .view
    }

    func test3(view: AnyView) -> AnyView {
        view.lux.tweak(.captionLayout).draw.surfaceBase
    }
}

// -------------

public extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: THEME INTERFACE

public extension View {
    var look: Look {
        Look.current
    }
}

// MARK: COLOR VALUES

public extension View {
    func lookPalette(color keypath: KeyPath<SurfaceProviderProtocol, Color> = \.normal, scheme: Look.Scheme? = nil) -> Color {
        switch scheme {
        case .light:
            return look.specLight.surface[keyPath: keypath]
        case .dark:
            return look.specDark.surface[keyPath: keypath]
        default:
            return look.spec.surface[keyPath: keypath]
        }
    }
}
