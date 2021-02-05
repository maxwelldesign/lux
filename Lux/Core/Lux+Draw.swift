//
//  Styling+Lux+Draw.swift
//  StylingLook
//
//  Created by mark maxwell on 2/12/20.
//  Copyright © 2020 eonflux. All rights reserved.
//
import SwiftUI

public extension Lux {
    struct Drawing: LuxRenderAPI {
        public typealias LuxRenderAPIType = Drawing

        public var lux: Lux
        public var tintScaleFactor: CGFloat = 0.5
    }
}

public extension Lux.Drawing {
    var surfaceElevation: AnyView {
        baseShape.fill(
            trait.surfaceElevationColor
        ).edgesIgnoringSafeArea(surfaceIgnoresSafeArea).anyView()
    }

    var surfaceBase: AnyView {
        surfaceElevation
    }

    var surfaceIgnoresSafeArea: Edge.Set {
        trait.surfaceIgnoresSafeArea ? .all : .init()
    }

    var surfaceComposition: AnyView {
        var surface = surfaceBase

        if trait.surface == .canvas {
            return surface.animation(.none).anyView()
        }

        if trait.spec.tint.full > 0 {
            surface = surface
                .overlay(
                    tintShapeTexture
                        .allowsHitTesting(false).disabled(true)
                        .edgesIgnoringSafeArea(surfaceIgnoresSafeArea)
                        .contentShape(Rectangle().path(in: .zero)))
                .anyView()
        }

        if trait.surface == .normal || trait.surface == .accent {
            return surface.animation(.none).anyView()
        }

//        if trait.spec.fill.full != 0 {
//            let fillView = fill
//            surface = surface.overlay(
//                fillView
//                    .edgesIgnoringSafeArea(surfaceIgnoresSafeArea).anyView()
//                    .contentShape(Rectangle().path(in: .zero)))
//                .anyView()
//        }

        return surface.animation(.none).anyView()
    }

    var tintShapeTexture: some View {
        let maxOpacity = 0.5
        let opacity = trait.spec.tint.full.doubleValue * trait.spec.tint.mixNormal.doubleValue * maxOpacity

        let colorA = trait.spec.color.tint.paint.opacity(opacity)
        let colorB = trait.spec.color.tint2.paint.opacity(opacity)
        let grad = Gradient(colors: [colorA, colorB])

        switch trait.spec.texture.style {
        case .linearGradient:
            return LinearGradient(gradient: grad, startPoint: trait.spec.texture.start, endPoint: trait.spec.texture.end).allowsHitTesting(false).disabled(true).contentShape(Rectangle().path(in: .zero))
        case .radialGradient:
            return LinearGradient(gradient: grad, startPoint: trait.spec.texture.start, endPoint: trait.spec.texture.end).allowsHitTesting(false).disabled(true).contentShape(Rectangle().path(in: .zero))
        }
    }

    //    var tint: AnyView {
    //        guard trait.spec.tint.enabled else { return baseShape.anyView() }
    //
    //        return baseShape
    //            //            .fill( tintShapeTexture)
    //            .allowsHitTesting(false)
    //            .blendMode(.color)
    //            .anyView()
    //    }

    var fill: AnyView {
        guard trait.spec.fill.enabled else { return baseShape.anyView() }

        let scale: CGFloat = 1.0
        let blur = max(1.0, 4 * scale + trait.spec.fill.flow * 4 * scale)
        let stroke = max(1.0, 44 * trait.spec.fill.full * scale)

        return baseShape
            .stroke(trait.spec.color.fill.paint, lineWidth: stroke)
            .scaleEffect(scale)
            .clipped()
            .blur(radius: blur)
            .blendMode(.overlay)
            .scaleEffect(1.0 / scale)
            .clipped()
            .opacity(1.0)
            .disabled(true)
            .allowsHitTesting(false)
            .anyView()
    }

    var border: AnyView {
        EmptyView().anyView()
    }

    var underline: AnyView {
        EmptyView().anyView()
    }
}

public extension Lux.Drawing {
    var panelBorder: AnyView {
        RoundedRectangle(cornerRadius: trait.cornerRadius)
            .stroke(trait.foregroundColor, lineWidth: 1)
            .opacity(0.1)
            .anyView()
    }

    var inputUnderlineColor: Color {
        trait.surface == .active ? .clear : trait.foregroundColor
    }

    var inputUnderline: AnyView {
        VStack {
            Spacer()
            Rectangle()
                .fill(inputUnderlineColor)
                .lux.feature(.inactiveOpacity).view
                .frame(height: trait.hairline2x)
        }
        .anyView()
    }
}

public extension Lux.Drawing {
    var surfaceSystemBlur: AnyView {
        VStack {
            HStack { Spacer() }
            Spacer()
        }
        .systemBlur(style: .regular)
        .anyView()
    }
}

public extension Lux.Drawing {
    var baseShape: some Shape {
        rectangle
    }

    var roundedRectangle: some Shape {
        RoundedRectangle(cornerRadius: lux.trait.cornerRadius)
    }

    var rectangle: some Shape {
        Rectangle()
    }
}
