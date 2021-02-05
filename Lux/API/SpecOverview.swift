//
//  File.swift
//  Lux
//
//  Created by Mark C Maxwell on 6/2/20.
//  Copyright © 2020 maxwell.design. All rights reserved.
//

import SwiftUI

public struct SpecificationOverview: View {
    var spec: SpecificationProtocol
    public init(spec: SpecificationProtocol) {
        self.spec = spec
    }

    var elevations: [Lux.Tweak] {
        [
            .elevationTop,
            .elevationAbove3x,
            .elevationAbove2x,
            .elevationAbove,
            .elevationNormal,
            .elevationBelow,
            .elevationBelow2x,
            .elevationBelow3x,
            .elevationBottom,
        ]
    }

    var elevationNames: [String] {
        [
            "Top",
            "+3x",
            "+2x",
            "+1x",
            "+0",
            "-1x",
            "-2x",
            "-3x",
            "Btm",
        ]
    }

    var surfaces: [Lux.Tweak] {
        [
            .activeSurface,
            .accentSurface,
            .normalSurface,
            .canvasSurface,
        ]
    }

    var colors: [Lux.Tweak] {
        [
            .primaryColor,
            .secondaryColor,
            .tertiaryColor,
        ]
    }

    var fonts: [Lux.Tweak] {
        [
            .primaryFont,
            .secondaryFont,
            .tertiaryFont,
        ]
    }

    func colors(for tweak: Lux.Tweak) -> [Lux.Tweak] {
        switch tweak {
        case .activeSurface, .accentSurface:
            return colors
        default:
            return [.none]
        }
    }

    var trait: Trait {
        Trait(spec: spec as? Look.Specification).tweak(.canvasSurface)
    }

    public var body: some View {
        Column {
            Row {
                Image(systemName: "bolt")
                    .lux
                    .trait(self.trait)
                    .tweak(.canvasSurface)
                    .style(.iconLarge, .text)
                    .view
                    .padding(4)
                    .lux
                    .feature(.shadow, .padding, .padding)
                    .view
            }

            Row {
                Image(systemName: "square.stack.3d.up.fill")
                    .lux
                    .trait(self.trait)
                    .style(.iconLarge, .text)
                    .view
                    .padding(4)
                    .background(Circle().stroke(self.spec.surface.active))
                    .lux
                    .feature(.shadow)
                    .view

                Text("\(String("\(self.spec.elevation.current)".prefix(5))) elevation")
                    .bold()
                    .lux
                    .trait(self.trait)
                    .tweak(.captionLayout)
                    .tweak(.primaryFont)
                    .style(.paragraph)
                    .feature(.rectangularContentShape)
                    .view
            }

            Row {
                Text("\(String("\(self.spec.tint.current)".prefix(4))) mix")
                    .bold()
                    .lux
                    .trait(self.trait)
                    .tweak(.captionLayout)
                    .tweak(.primaryFont)
                    .style(.paragraph)
                    .feature(.rectangularContentShape)
                    .view
                Image(systemName: "slider.horizontal.3")
                    .lux
                    .trait(self.trait)
                    .style(.iconLarge, .text)
                    .view
                    .padding(4)
                    .background(Circle().stroke(self.spec.surface.active))
                    .lux
                    .feature(.shadow)
                    .view
            }

            Row {
                Group {
                    HStack {
                        Column {
                            Row {
                                Image(systemName: "lightbulb")
                                    .lux
                                    .trait(self.trait)
                                    .style(.iconLarge, .text)
                                    .view
                                    .padding(4)
                                    .background(Circle().fill(self.spec.color.tint.paint))
                                    .lux
                                    .feature(.shadow)
                                    .view
                            }
                            Row {
                                Text(self.spec.texture.start.name)
                                    .lux
                                    .tweak(.captionLayout)
                                    .trait(self.trait)
                                    .view
                            }
                        }
                        .lux
                        .feature(.flexibleWidth, .padding)
                        .view
                    }

                    HStack {
                        Column {
                            Row {
                                Image(systemName: "lightbulb")
                                    .lux
                                    .trait(self.trait)
                                    .style(.iconLarge, .text)
                                    .view
                                    .padding(4)
                                    .background(Circle().fill(self.spec.color.tint2.paint))
                                    .lux
                                    .feature(.shadow)
                                    .view
                            }
                            Row {
                                Text(self.spec.texture.end.name)
                                    .lux
                                    .tweak(.captionLayout)
                                    .trait(self.trait)
                                    .view
                            }
                        }
                        .lux
                        .feature(.flexibleWidth, .padding)
                        .view
                    }
                }
            }

            Row {
                Text("3D-Flat Lighting")
                    .bold()
                    .lux
                    .trait(self.trait)
                    .tweak(.titleLayout)
                    .tweak(.primaryFont)
                    .style(.paragraph)
                    .feature(.rectangularContentShape, .padding)
                    .view
            }

            self.makeSurfaces()

            Row {
                Rectangle()
                    .fill(self.spec.surface.foregroundLight)
                    .overlay(Text("Light").foregroundColor(self.spec.surface.foregroundLight).colorInvert())

                Rectangle()
                    .fill(self.spec.surface.foregroundDark)
                    .overlay(Text("Dark").foregroundColor(self.spec.surface.foregroundDark).colorInvert())
            }
            .frame(height: 66)
            .lux
            .style(.layoutBlock)
            .feature(.shadow)
            .view

            ParagraphGroup {
                Group {
                    Text("72 Surfaces")
                        .bold()
                        .lux
                        .trait(self.trait)
                        .tweak(.largeTitleLayout)
                        .tweak(.primaryFont)
                        .style(.paragraph)
                        .feature(.shadow, .shadow, .shadow, .rectangularContentShape)
                        .view

                    Text("8 Paragraph Layouts")
                        .bold()
                        .lux
                        .trait(self.trait)
                        .tweak(.headlineLayout)
                        .tweak(.secondaryFont)
                        .style(.paragraph)
                        .feature(.shadow, .shadow, .rectangularContentShape)
                        .view

                    Text("3 Fonts")
                        .bold()
                        .lux
                        .trait(self.trait)
                        .tweak(.headlineLayout)
                        .tweak(.tertiaryFont)
                        .style(.paragraph)
                        .feature(.shadow, .rectangularContentShape)
                        .view
                }
            }

            ZStack {
                Column {
                    Text("\(Int(self.spec.padding.base))px Padding")
                        .lux
                        .trait(self.trait)
                        .tweak(.captionLayout)
                        .style(.paragraph)
                        .feature(.rectangularContentShape)
                        .view

                    Text("\(Int(self.spec.padding.base))px Margin")
                        .lux
                        .trait(self.trait)
                        .tweak(.captionLayout)
                        .style(.paragraph)
                        .feature(.rectangularContentShape)
                        .view

                    Text("\(Int(self.spec.cornerRadius.base))px Radius")
                        .lux
                        .trait(self.trait)
                        .tweak(.captionLayout)
                        .style(.paragraph)
                        .feature(.rectangularContentShape)
                        .view
                }
                .frame(width: 123, height: 123)
                .overlay(
                    self.lux.draw.roundedRectangle
                        .stroke(self.spec.surface.active, lineWidth: 2)
                )

                Row {
                    Spacer()
                }
                .frame(width: 123 + self.spec.padding.base.double, height: 123 + self.spec.padding.base.double)
                .overlay(
                    self.lux.draw.roundedRectangle
                        .stroke(self.spec.surface.active, lineWidth: 2)
                )
                .lux
                .feature(.secondaryOpacity)
                .view

                Row {
                    Spacer()
                }
                .frame(width: 123 + self.spec.padding.base.double.double, height: 123 + self.spec.padding.base.double.double)
                .overlay(
                    self.lux.draw.roundedRectangle
                        .stroke(self.spec.surface.active, lineWidth: 2)
                )
                .lux
                .feature(.inactiveOpacity)
                .view
            }
        }
        .lux
        .style(.panel)
        .view
    }

    func name(for tweak: Lux.Tweak) -> String {
        switch tweak {
        case .canvasSurface:
            return "Canvas Surface"
        case .normalSurface:
            return "Normal Surface"
        case .accentSurface:
            return "Accent Surfaces"
        case .activeSurface:
            return "Active Surfaces"
        default:
            return ""
        }
    }

    func makeSurfaces() -> some View {
        Column {
            ForEach(self.surfaces, id: \.self) { surface in
                Group {
                    Row {
                        Text(self.name(for: surface))
                            .lineLimit(1)
                            .fixedSize()
                            .lux
                            .trait(self.trait)
                            .tweak(.headlineLayout)
                            .style(.paragraph)
                            .feature(.secondaryOpacity)
                            .view
                    }
                    Column {
                        ForEach(Array(self.colors(for: surface).enumerated()), id: \.element) { _, color in
                            Row {
                                ForEach(Array(self.elevations.enumerated()), id: \.element) { idx, elevation in
                                    Text(self.elevationNames[idx])
                                        .lineLimit(1)
                                        .frame(height: 123)
                                        .fixedSize()
                                        .lux
                                        .trait(self.trait)
                                        .tweak(.captionLayout)
                                        .feature(.flexibleWidth, .fontTypography)
                                        .tweak(surface)
                                        .tweak(elevation)
                                        .tweak(color)
                                        .feature(.backgroundSurfaceComposition, .foregroundColor)
                                        .view

                                }.animation(.easeInOut)
                            }
                        }
                    }
                    .lux
                    .unless(surface == .canvasSurface) { $0.feature(.shadow) }
                    .view
                    .drawingGroup(opaque: true)
                }
            }
            .lux
            .style(.layoutBlock)
            .feature(.shadow)
            .view
        }
    }
}

struct SpecificationOverview_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
