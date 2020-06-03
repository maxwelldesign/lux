//
//  Styling+Lux+Presets.swift
//  Styling
//
//  Created by mark maxwell on 2/25/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import Foundation

public extension Lux.Style {
    static let Make: Lux.EffectBuilder = { Lux.Style(tweaks: $0, features: $1) }
    static let MakeFeaturing: Lux.EffectBaseBuilder = { Lux.Style(tweaks: [], features: $0) }
}

public extension Lux.Style {
    // MARK: Containers

    static let none = Make([], [])

    static let onPanel = Make(
        [.elevationNormal], []
    )

    static let onBar = Make(
        [
            .elevationAbove,
            .elevationNormalOnCanvas,
        ], []
    )

    static let onButton = Make(
        [
            .elevationAbove2x,
            .elevationNormalOnCanvas,
            .surfaceClearOnCanvas,
        ],
        []
    )

    static let onTextField = Make(
        [.elevationInputSurface], []
    )

    static let panel = Make(
        onPanel.tweaks +
            [
                .paddingZero,
            ],
        [
            .flexibleWidth,
            .backgroundSurfaceComposition,
            .foregroundColor,
        ]
    )

    static let panelWithBorder = Make(
        panel.tweaks,
        panel.features + [.panelBorder]
    )

    static let card = Make(
        panel.tweaks,
        panel.features + [.cornerRadius]
    )

    static let bar = Make(
        onBar.tweaks +
            [
                .paddingQuarter,
                .cornerRadiusZero,
            ],
        [
            .padding,
            .backgroundSurfaceComposition,
            .foregroundColor,
            .flexibleWidth,
            .backgroundSurfaceComposition,
        ]
    )

    // MARK: Elements

    static let iconLarge = MakeFeaturing(
        [
            .padding,
            .iconFixedSize,
        ]
    )

    static let buttonLarge = Make(
        iconLarge.tweaks + onButton.tweaks,
        [
            .padding,
            .backgroundSurfaceComposition,
            .foregroundColor,
            .cornerRadius,
            .margin,
            //            .rectangularContentShape //not recommended
        ]
    )

    static let textfieldLarge = Make(
        onTextField.tweaks,
        [
            .padding,
            .backgroundSurfaceComposition,
            .foregroundColor,
            .inputUnderline,
            .cornerRadius,
            .margin,
        ]
    )

    // MARK: Elements Composed

    static let icon = Make(
        iconLarge.tweaks + compact.tweaks,
        iconLarge.features
    )

    static let button = Make(
        buttonLarge.tweaks + compact.tweaks,
        buttonLarge.features
    )

    static let textfield = Make(
        textfieldLarge.tweaks + compact.tweaks,
        textfieldLarge.features
    )

    // MARK: Composable

    static let compact = Make(
        [.paddingHalf], []
    )

    static let separator = MakeFeaturing(
        [.separatorFrame]
    )

    static let typography = MakeFeaturing(
        [
            .foregroundColor,
            .fontTypography,
        ]
    )

    static let text = MakeFeaturing(
        [
            .fontTypography,
        ]
    )

    static let accentColor = Make(
        [
            .accentSurface,
        ],
        [
            .foregroundColor,
            .fontTypography,
            .accentColor,
        ]
    )

    static let touchesDisabled = MakeFeaturing(
        [
            .disabledHitTesting,
            .emptyContentShape,
        ]
    )

    // MARK: Layout

    static let layoutBlock = MakeFeaturing(
        typography.features + [.padding]
    )

    static let layoutElement = Make(
        [.edgesBottom],
        typography.features + [.padding]
    )

    static let paragraph = MakeFeaturing(
        typography.features +
            [
                .verticallyFixed,
                .paragraphPadding,
            ]
    )

    static let multiParagraphBlock = MakeFeaturing(
        typography.features +
            [
                .padding,
            ]
    )

    static let paragraphBlock = MakeFeaturing(
        paragraph.features + multiParagraphBlock.features
    )
}
