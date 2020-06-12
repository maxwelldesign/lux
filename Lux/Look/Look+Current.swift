//
//  Lux+Global.swift
//  Lux
//
//  Created by mark maxwell on 5/22/20.
//  Copyright © 2020 maxwell.design. All rights reserved.
//

import Foundation

extension Look {
    public class CurrentState: ObservableObject {
        @Published var base = Look()
        @Published var active: Look?
    }
}

extension Look {
    public static let state = CurrentState()

    public static func set(active: Look) {
        state.active = active
    }

    public static var current: Look {
        state.active ?? state.base
    }
}
