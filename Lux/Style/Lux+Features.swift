//
//  Styling+Lux+Modifiers.swift
//  Styling
//
//  Created by mark maxwell on 2/19/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI

public extension Lux {
    enum Feature: String, Codable {
        case none

        // MARK: Foreground Color

        case foregroundColor
        case accentColor

        // MARK: Surface Rendering

        case backgroundSurfaceBase
        case backgroundSurfaceComposition
        case backgroundSurfaceWithForegroundColor
        case backgroundSystemBlur

        // MARK: Padding

        case padding
        case margin
        case headerPadding
        case bodyPadding
        case footerPadding
        case hairlinePadding
        case hairlinePadding2x
        case paragraphPadding

        // MARK: Layout

        case paragraph
        case controlLayout

        // MARK: Typography

        case fontTypography

        // MARK: Icon

        case iconFixedSize

        // MARK: CornerRadius

        case cornerRadius

        // MARK: Opacity

        case disabledOpacity
        case inactiveOpacity
        case secondaryOpacity

        // MARK: Visibility

        case invisible
        case hidden

        // MARK: Separators

        case separatorHeight
        case separatorFrame

        // MARK: Utils

        case panelBorder
        case inputUnderline
        case shadow
        case rectangularContentShape
        case emptyContentShape
        case disabledHitTesting

        // MARK: Frame

        case flexibleWidth
        case flexibleHeight
        case flexibleFrame
        case screenWidth
        case screenHeight
        case screenFrame

        // MARK: Frame Fix

        case horizontallyFixed
        case verticallyFixed
        case fixedSize

        // MARK: Aspect Ratio

        case fillAspectRatio
        case fitAspectRatio
    }
}

extension Lux.Style {
    static let style: Lux.EffectBuilder = { Lux.Style(tweaks: $0, features: $1) }
    static let fx: Lux.EffectBaseBuilder = { Lux.Style(tweaks: [], features: $0) }
}

extension Lux.Style {
    func render(to lux: Lux) {
        tweaks.forEach { $0.render(to: lux) }
        features.forEach { $0.render(to: lux) }
    }
}

extension Lux.Feature {
    func render(to lux: Lux) {
        switch self {
        case .none:
            break
        case .foregroundColor:
            lux.render.viewMutation {
                $0
                    .foregroundColor(lux.trait.foregroundColor).anyView()
            }
        case .backgroundSurfaceBase:
            lux.render.viewMutation {
                $0
                    .background(lux.draw.surfaceBase)
                    .anyView()
            }
        case .backgroundSurfaceComposition:
            lux.render.viewMutation {
                $0
                    .background(lux.draw.surfaceComposition)
                    .anyView()
            }
        case .backgroundSurfaceWithForegroundColor:
            _ = lux.feature(.foregroundColor, .backgroundSurfaceComposition)
        case .padding:
            lux.render.viewMutation {
                $0.padding(lux.trait.edges.padding, lux.trait.padding).anyView()
            }
        case .margin:
            lux.render.viewMutation {
                $0.padding(lux.trait.edges.margin, lux.trait.margin).anyView()
            }
        case .headerPadding:
            lux.render.viewMutation {
                $0.padding(lux.trait.headerParagraphPadding).anyView()
            }
        case .bodyPadding:
            lux.render.viewMutation {
                $0.padding(lux.trait.bodyParagraphPadding).anyView()
            }
        case .footerPadding:
            lux.render.viewMutation {
                $0.padding(lux.trait.footerParagraphPadding).anyView()
            }
        case .hairlinePadding:
            lux.render.viewMutation {
                $0.padding(lux.trait.edges.padding, lux.trait.hairline).anyView()
            }
        case .hairlinePadding2x:
            lux.render.viewMutation {
                $0.padding(lux.trait.edges.margin, lux.trait.hairline2x).anyView()
            }
        case .paragraph:
            _ = lux.feature(.foregroundColor, .fontTypography, .paragraphPadding)
        case .controlLayout:
            _ = lux.feature(.foregroundColor, .fontTypography, .padding)
        case .paragraphPadding:
            lux.render.viewMutation {
                $0
                    .padding(lux.trait.paragraphPadding)
                    .anyView()
            }
        case .fontTypography:
            lux.render.viewMutation {
                $0
                    .font(lux.trait.typography)
                    .anyView()
            }
        case .iconFixedSize:
            lux.render.viewMutation {
                $0
                    .fixedSize()
                    .anyView()
            }
        case .cornerRadius:
            lux.render.viewMutation {
                $0
                    .cornerRadius(lux.trait.cornerRadius)
                    .anyView()
            }
        case .disabledOpacity:
            lux.render.viewMutation {
                $0
                    .opacity(lux.trait.tertiaryOpacity.doubleValue)
                    .anyView()
            }
        case .inactiveOpacity:
            lux.render.viewMutation {
                $0
                    .opacity(lux.trait.secondaryOpacity.doubleValue)
                    .anyView()
            }
        case .secondaryOpacity:
            lux.render.viewMutation {
                $0
                    .opacity(lux.trait.primaryOpacity.doubleValue)
                    .anyView()
            }

        case .panelBorder:
            lux.render.viewMutation {
                $0
                    .overlay(lux.draw.panelBorder)
                    .anyView()
            }
        case .inputUnderline:
            lux.render.viewMutation {
                $0
                    .overlay(lux.draw.inputUnderline)
                    .anyView()
            }
        case .separatorHeight:
            lux.render.viewMutation {
                $0
                    .frame(height: lux.trait.separationMargin)
                    .anyView()
            }
        case .separatorFrame:
            _ = lux.feature(.separatorHeight, .flexibleWidth)

        case .shadow:
            lux.render.viewMutation {
                $0.shadow(
                    color: lux.trait.shadowColor,
                    radius: lux.trait.shadowRadius,
                    x: 0,
                    y: lux.trait.shadowOffsetY
                ).anyView()
            }
        case .backgroundSystemBlur:
            lux.render.viewMutation {
                $0.background(
                    lux.draw.surfaceSystemBlur
                ).anyView()
            }
        case .accentColor:
            lux.render.viewMutation {
                $0
                    .accentColor(lux.trait.tweak(.activeSurface).surfaceColor)
                    .anyView()
            }
        case .rectangularContentShape:
            lux.render.viewMutation {
                $0
                    .contentShape(Rectangle())
                    .anyView()
            }

        case .emptyContentShape:
            lux.render.viewMutation {
                $0
                    .contentShape(Rectangle().path(in: .zero))
                    .anyView()
            }

        case .disabledHitTesting:
            lux.render.viewMutation {
                $0
                    .allowsHitTesting(false)
                    .anyView()
            }

        case .invisible:
            lux.render.viewMutation {
                $0
                    .opacity(0)
                    .anyView()
            }
        case .hidden:
            lux.render.viewMutation {
                $0
                    .hidden()
                    .anyView()
            }

        case .flexibleWidth:
            lux.render.viewMutation {
                $0
                    .frame(minWidth: 0.0, maxWidth: .greatestFiniteMagnitude)
                    .anyView()
            }

        case .flexibleHeight:
            lux.render.viewMutation {
                $0
                    .frame(minHeight: 0.0, maxHeight: .greatestFiniteMagnitude)
                    .anyView()
            }

        case .screenWidth:
            lux.render.viewMutation {
                $0
                    .frame(minWidth: 0.0, maxWidth: .screenWidth)
                    .anyView()
            }

        case .screenHeight:
            lux.render.viewMutation {
                $0
                    .frame(minHeight: 0.0, maxHeight: .screenHeight)
                    .anyView()
            }

        case .flexibleFrame:
            _ = lux.feature(.flexibleWidth, .flexibleHeight)
        case .screenFrame:
            _ = lux.feature(.screenWidth, .screenHeight)

        case .horizontallyFixed:
            lux.render.viewMutation {
                $0
                    .fixedSize(horizontal: true, vertical: false)
                    .anyView()
            }
        case .verticallyFixed:
            lux.render.viewMutation {
                $0
                    .fixedSize(horizontal: false, vertical: true)
                    .anyView()
            }
        case .fixedSize:
            lux.render.viewMutation {
                $0
                    .fixedSize(horizontal: true, vertical: true)
                    .anyView()
            }
        case .fillAspectRatio:
            lux.render.viewMutation {
                $0
                    .aspectRatio(contentMode: .fill)
                    .anyView()
            }
        case .fitAspectRatio:
            lux.render.viewMutation {
                $0
                    .aspectRatio(contentMode: .fit)
                    .anyView()
            }
        }
    }
}
