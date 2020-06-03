//
//  View+SystemBlur.swift
//  SwiftUIBlurView
//
//  Created by Daniel Saidi on 2019-11-26.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import SwiftUI
import UIKit

public extension View {
    func systemBlur(style: UIBlurEffect.Style) -> some View {
        #if targetEnvironment(macCatalyst)
            return overlay(lux.spec.surface.canvas).lux.view
        #else
            return overlay(BlurView(style: style)).lux.view
        #endif
    }
}
