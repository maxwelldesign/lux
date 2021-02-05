//
//  Styling+Lux+Traits.swift
//  Styling
//
//  Created by mark maxwell on 2/25/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import Foundation

public extension Lux {
    enum Tweak: String, Codable {
        case none

        // MARK: Fonts

        case primaryFont
        case secondaryFont
        case tertiaryFont

        // MARK: Colors

        case primaryColor
        case secondaryColor
        case tertiaryColor
        case activeColor
        case contrastColor

        // MARK: Typo

        case typoSorted
        case typoMixed

        // MARK: Layout

        case largeTitleLayout
        case titleLayout
        case headlineLayout
        case subheadlineLayout
        case bodyLayout
        case calloutLayout
        case captionLayout
        case footerLayout

        // MARK: Surface

        case canvasSurface
        case normalSurface
        case accentSurface
        case activeSurface

        // MARK: Surface complement

        case complementary
        case complementarySurface
        case complementaryLayout
        case complementaryFont
        case complementaryColor

        // MARK: Elevation

        case elevationNormal
        case elevationAbove
        case elevationAbove2x
        case elevationAbove3x
        case elevationTop
        case elevationBelow
        case elevationBelow2x
        case elevationBelow3x
        case elevationBottom
        case elevationNormalOnCanvas
        case elevationInputSurface
        case surfaceClearOnCanvas
        case surfaceRenderAlways

        // MARK: Layout Multipliers

        case layoutMultiplierZero
        case layoutMultiplierBase
        case layoutMultiplierHalf
        case layoutMultiplierQuater
        case layoutMultiplierEighth

        // MARK: Padding

        case paddingZero
        case paddingBase
        case paddingHalf
        case paddingQuarter
        case paddingEighth

        // MARK: Corner Radius

        case cornerRadiusZero
        case cornerRadiusBase
        case cornerRadiusHalf
        case cornerRadiusQuarter
        case cornerRadiusEighth

        // MARK: Edges

        case edgesNone
        case edgesVertical
        case edgesHorizontal
        case edgesTop
        case edgesBottom
        case edgesLeading
        case edgesTrailing

        // MARK: Color Scheme

        case lightSpec
        case darkSpec
        case defaultSpec
    }
}

extension Lux.Tweak {
    func render(to lux: Lux) {
        lux.render.traitMutation {
            apply(to: $0)
        }
    }

    func apply(to trait: Trait) -> Trait {
        var mutation = trait
        switch self {
        case .none:
            return mutation
        case .primaryFont:
            mutation.fontPriority = .primary
            return mutation
        case .secondaryFont:
            mutation.fontPriority = .secondary
            return mutation

        case .tertiaryFont:
            mutation.fontPriority = .tertiary
            return mutation

        case .primaryColor:
            mutation.colorOverride = nil
            mutation.colorPriority = .primary
            return mutation

        case .secondaryColor:
            mutation.colorOverride = nil
            mutation.colorPriority = .secondary
            return mutation

        case .tertiaryColor:
            mutation.colorOverride = nil
            mutation.colorPriority = .tertiary
            return mutation

        case .activeColor:
            mutation.surface = .active
//            mutation.colorOverride = Look.current.surface.active(trait.elevation)
            return mutation

        case .contrastColor:
            mutation.surface = .active
//            mutation.colorOverride = Look.current.surface.contrast(trait.elevation).contrast
            return mutation

        case .typoSorted:
            mutation.preferredFontMix = .byPriority
            return mutation

        case .typoMixed:
            mutation.preferredFontMix = .mixed
            return mutation

        case .largeTitleLayout:
            mutation.layout = .largeTitle
            return mutation

        case .titleLayout:
            mutation.layout = .title
            return mutation

        case .headlineLayout:
            mutation.layout = .headline
            return mutation

        case .subheadlineLayout:
            mutation.layout = .subheadline
            return mutation

        case .bodyLayout:
            mutation.layout = .body
            return mutation

        case .calloutLayout:
            mutation.layout = .callout
            return mutation

        case .captionLayout:
            mutation.layout = .caption
            return mutation

        case .footerLayout:
            mutation.layout = .footnote
            return mutation

        case .canvasSurface:
            mutation.surface = .canvas
            return mutation

        case .normalSurface:
            mutation.surface = .normal
            return mutation

        case .accentSurface:
            mutation.surface = .accent
            return mutation

        case .activeSurface:
            mutation.surface = .active
            return mutation

        case .complementarySurface:
            switch mutation.surface {
            case .canvas:
                mutation.surface = .normal
            case .normal:
                mutation.surface = .accent
            case .accent:
                mutation.surface = .active
            case .active:
                mutation.surface = .canvas
            }
            return mutation

        case .complementaryLayout:
            switch mutation.layout {
            case .largeTitle:
                mutation.layout = .title
            case .title:
                mutation.layout = .headline
            case .headline, .subheadline:
                mutation.layout = .body
            case .body:
                mutation.layout = .callout
            case .callout:
                mutation.layout = .body
            case .caption:
                mutation.layout = .body
            case .footnote:
                mutation.layout = .body
            default:
                break
            }
            return mutation

        case .complementaryFont:
            switch mutation.fontPriority {
            case .primary:
                mutation.fontPriority = .secondary
            case .secondary:
                mutation.fontPriority = .tertiary
            case .tertiary:
                mutation.fontPriority = .primary
            }
            return mutation

        case .complementaryColor:
            switch mutation.colorPriority {
            case .primary:
                mutation.colorPriority = .secondary
            case .secondary:
                mutation.colorPriority = .tertiary
            case .tertiary:
                mutation.colorPriority = .primary
            }
            return mutation

        case .complementary:
            return mutation.tweak(.complementaryFont, .complementaryLayout, .complementaryColor)

        case .elevationNormal:
            mutation.elevation = .normal
            return mutation

        case .elevationAbove:
            mutation.elevation = .above
            return mutation

        case .elevationAbove2x:
            mutation.elevation = .above2x
            return mutation

        case .elevationAbove3x:
            mutation.elevation = .above3x
            return mutation

        case .elevationTop:
            mutation.elevation = .highlight
            return mutation

        case .elevationBelow:
            mutation.elevation = .below
            return mutation

        case .elevationBelow2x:
            mutation.elevation = .below2x
            return mutation

        case .elevationBelow3x:
            mutation.elevation = .below3x
            return mutation

        case .elevationBottom:
            mutation.elevation = .shadow
            return mutation

        case .elevationNormalOnCanvas:
            mutation.elevation = mutation.surface == .canvas ? .normal : mutation.elevation
            return mutation

        case .elevationInputSurface:
            switch mutation.surface {
            case .canvas:
                mutation.elevation = .normal
            case .normal:
                mutation.elevation = .above
            case .accent:
                mutation.elevation = .above
            case .active:
                mutation.elevation = .below
            }
            return mutation

        case .surfaceClearOnCanvas:
            mutation.canvasRenderMode = .clear
            return mutation

        case .surfaceRenderAlways:
            mutation.canvasRenderMode = .surface
            return mutation

        case .paddingZero:
            mutation.multipliers.padding = .zero
            return mutation

        case .paddingBase:
            mutation.multipliers.padding = .base
            return mutation

        case .paddingHalf:
            mutation.multipliers.padding = .half
            return mutation

        case .paddingQuarter:
            mutation.multipliers.padding = .quarter
            return mutation

        case .paddingEighth:
            mutation.multipliers.padding = .eighth
            return mutation

        case .cornerRadiusZero:
            mutation.multipliers.cornerRadius = .zero
            return mutation

        case .cornerRadiusBase:
            mutation.multipliers.cornerRadius = .base
            return mutation

        case .cornerRadiusHalf:
            mutation.multipliers.cornerRadius = .half
            return mutation

        case .cornerRadiusQuarter:
            mutation.multipliers.cornerRadius = .quarter
            return mutation

        case .cornerRadiusEighth:
            mutation.multipliers.cornerRadius = .eighth
            return mutation

        case .layoutMultiplierZero:
            mutation.multipliers.layout = .zero
            return mutation

        case .layoutMultiplierBase:
            mutation.multipliers.layout = .base
            return mutation

        case .layoutMultiplierHalf:
            mutation.multipliers.layout = .half
            return mutation

        case .layoutMultiplierQuater:
            mutation.multipliers.layout = .quarter
            return mutation

        case .layoutMultiplierEighth:
            mutation.multipliers.layout = .eighth
            return mutation

        case .edgesNone:
            mutation.edges.padding = .init()
            return mutation

        case .edgesVertical:
            mutation.edges.padding = .vertical
            return mutation

        case .edgesHorizontal:
            mutation.edges.padding = .horizontal
            return mutation
        case .edgesTop:
            mutation.edges.padding = .top
            return mutation

        case .edgesBottom:
            mutation.edges.padding = .bottom
            return mutation

        case .edgesLeading:
            mutation.edges.padding = .leading
            return mutation

        case .edgesTrailing:
            mutation.edges.padding = .trailing
            return mutation

        case .lightSpec:
            mutation.preferredColorScheme = .light
            return mutation

        case .darkSpec:
            mutation.preferredColorScheme = .dark
            return mutation

        case .defaultSpec:
            mutation.preferredColorScheme = nil
            return mutation
        }
    }
}
