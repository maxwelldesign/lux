//
//  LookDisplay.swift
//  Lux
//
//  Created by Mark C Maxwell on 6/2/20.
//  Copyright © 2020 maxwell.design. All rights reserved.
//

import SwiftUI

public struct LookDisplay: View {
    var look: Look
    var active = false
    var salt: String?
    var height: CGFloat?
    var maxWidth: CGFloat? = 640

    var onEdit: (() -> Void)?
    var showIcons = true
    var flipped = false
    var realtime = true
    var cornerRadius = true
    var animate = true

    public init(
        look: Look,
        active: Bool = false,
        salt: String? = nil,
        height: CGFloat? = nil,
        maxWidth: CGFloat? = 640,
        onEdit: (() -> Void)? = nil,
        showIcons: Bool = true,
        animate: Bool = true,
        flipped: Bool = false,
        realtime: Bool = true,
        cornerRadius: Bool = true
    ) {
        self.look = look
        self.active = active
        self.salt = salt
        self.height = height
        self.maxWidth = maxWidth

        self.onEdit = onEdit
        self.showIcons = showIcons
        self.animate = animate
        self.flipped = flipped
        self.realtime = realtime
        self.cornerRadius = cornerRadius
    }

    var lookWithCurrentSpec: Look {
        let newLook = look.clone()
        newLook.preferredScheme = Look.current.preferredScheme
        return newLook
    }

    public var body: some View {
        Column {
            self.content
                .frame(maxWidth: self.maxWidth)
        }
    }

    var content: some View {
        let specs = !flipped ?

            { Column {
                SpecificationDisplay(spec: self.look.specDark, intention: .dark, showIcons: self.showIcons, animate: self.animate, flipped: self.flipped, realtime: self.realtime)
                SpecificationDisplay(spec: self.look.specLight, intention: .light, showIcons: self.showIcons, animate: self.animate, flipped: self.flipped, realtime: self.realtime)
            } } :
            { Column {
                SpecificationDisplay(spec: self.look.specLight, intention: .light, showIcons: self.showIcons, animate: self.animate, flipped: self.flipped, realtime: self.realtime)
                SpecificationDisplay(spec: self.look.specDark, intention: .light, showIcons: self.showIcons, animate: self.animate, flipped: self.flipped, realtime: self.realtime)
            } }
        return Column {
            specs()
                .overlay(
                    specs()
                        .scaleEffect(x: -1.0, y: -1.0, anchor: .center)
                        .opacity(1.0)
                        .mask(
                            Column {
                                Row { Spacer() }
                                Spacer()
                                Text(self.look.name.uppercased())
                                    .bold()
                                    .modifier(FitFontToWidth(
                                        font: self.look.spec.font.active,
                                        fraction: 1.0
                                    ))

                                Spacer()
                            }
                        )
                )
                .lux
                .if(self.realtime) { $0.view.drawingGroup(opaque: true).lux.view }
                .view
                .contentShape(Rectangle())
                .onTapGesture {
                    self.onEdit?()
                }

                .lux
                .if(self.height != nil) { $0.view.frame(height: self.height).lux.view }
                .trait(Trait(spec: self.look.spec))
                .if(self.cornerRadius) { $0.feature(.cornerRadius) }
                .view
        }
        .lux
        .view
    }
}

public struct SpecificationDisplay: View {
    //    var name: String
    var spec: SpecificationProtocol
    var intention: ColorScheme

    var showIcons = true
    var flipped = false
    var realtime = true
    var animate = true

    @State var _appeared = false

    public init(
        spec: SpecificationProtocol,
        intention: ColorScheme,
        showIcons: Bool = true,
        animate: Bool = true,
        flipped: Bool = false,
        realtime: Bool = true
    ) {
        self.spec = spec
        self.intention = intention

        self.showIcons = showIcons
        self.animate = animate
        self.flipped = flipped
        self.realtime = realtime
    }

    @State var displayTimer: Timer?

    var fontColor: Color {
        spec.surface.canvas.contrast
    }

    var intendedPalette: [Color] {
        let palette = flipped ? self.palette.reversed() : self.palette
        return intention == .light ? palette : palette
    }

    var maxWidth: CGFloat {
        appeared ? .greatestFiniteMagnitude : 2
    }

    var baseColor: Color {
        intention == .light ? spec.surface.foregroundLight : spec.surface.foregroundDark
    }

    var offsetMag: CGFloat {
        100
    }

    var offset: CGFloat {
        appeared ? 0 : intention == .light ? offsetMag : -offsetMag
    }

    var angle: Double {
        appeared ? 0 : intention == .light ? -45 : 45
    }

    var scaleval: CGFloat {
        appeared ? 1 : 0.1
    }

    var appeared: Bool {
        guard animate else {
            return true
        }
        return _appeared
    }

    func startShowing() {
        guard animate else { return }

        displayTimer?.invalidate()
        let timer = Timer(timeInterval: 0.369, repeats: false) { time in
            time.invalidate()
            DispatchQueue.main.async {
                self._appeared = true
            }
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        displayTimer = timer
    }

    public var body: some View {
        GeometryReader { geo in
            Row {
                ForEach(Array(self.intendedPalette.enumerated()), id: \.element) { _, color in
                    Rectangle()
                        .fill(self.appeared ? color : self.baseColor)
                        .frame(height: 1)
                }
            }
            .scaleEffect(x: 1, y: geo.size.height, anchor: .center)
            .frame(height: geo.size.height)
            .overlay(
                self.lux.trait(Trait(spec: self.spec as? Look.Specification)).draw.tintShapeTexture
            )
            .lux
            .if(self.realtime) { $0.view.drawingGroup(opaque: true).lux.view }
            .view
            .animation(.easeInOut(duration: 0.5))
            .lux
            .feature(.flexibleWidth)
            .view
            .overlay(
                self.showIcons ?
                    HStack {
                        self.intention == .light ?
                            Group {
                                Spacer()
                                Image(systemName: "sun.max")
                                    .imageScale(.small)
                                    .scaleEffect(self.scaleval)
                            }.lux.view :
                            Group {
                                Image(systemName: "moon")
                                    .imageScale(.small)
                                    .scaleEffect(self.scaleval)
                                Spacer()
                            }.lux.view
                    }
                    .foregroundColor(self.spec.color.shadow.contrast.paint)
                    .font(Font(self.spec.font.primary.withSize(self.look.specDark.font.titleSize)))
                    .shadow(color: self.spec.color.shadow.paint, radius: self.spec.shadow.currentNormal)
                    .lux
                    .feature(.flexibleWidth)
                    .view
                    .padding()
                    .animation(.easeInOut(duration: 0.25))
                    : nil
            )

            .onAppear {
                self.startShowing()
            }.onDisappear {
                self.displayTimer?.invalidate()
            }
        }
    }

    var trait: Trait {
        Trait(spec: spec as? Look.Specification)
    }

    var palette: [Color] {
        [
            trait.tweak(.canvasSurface, .elevationAbove).surfaceElevationColor,
            trait.tweak(.canvasSurface, .elevationBelow).surfaceElevationColor,
            trait.tweak(.normalSurface, .elevationAbove).surfaceElevationColor,
            trait.tweak(.normalSurface, .elevationBelow).surfaceElevationColor,
            trait.tweak(.accentSurface, .elevationNormal).surfaceElevationColor,
            spec.color.tertiary.paint,
            spec.color.secondary.paint,
            spec.color.primary.paint,
            trait.tweak(.activeSurface, .elevationBelow).surfaceElevationColor,
            trait.tweak(.activeSurface, .elevationAbove).surfaceElevationColor,
        ]
    }
}

public struct FitFontToWidth: ViewModifier {
    var font: UIFont = .systemFont(ofSize: 1000)
    var fraction: CGFloat = 1.0
    var minSize: CGFloat = 8
    var maxSize: CGFloat = 1000
    var minimumScaleFactor: CGFloat {
        minSize / maxSize
    }

    public init(
        font: UIFont = .systemFont(ofSize: 1000),
        fraction: CGFloat = 1.0,
        minSize: CGFloat = 8,
        maxSize: CGFloat = 1000
    ) {
        self.font = font
        self.fraction = fraction
        self.minSize = minSize
        self.maxSize = maxSize
    }

    public func body(content: Content) -> some View {
        GeometryReader { g in
            content
                .font(Font(self.font.withSize(self.maxSize)))
                .minimumScaleFactor(self.minimumScaleFactor)
                .lineLimit(1)
                .frame(width: g.size.width * self.fraction)
        }
    }
}
