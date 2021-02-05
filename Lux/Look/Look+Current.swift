//
//  Lux+Global.swift
//  Lux
//
//  Created by mark maxwell on 5/22/20.
//  Copyright © 2020 maxwell.design. All rights reserved.
//

import Foundation

public extension Look {
    class CurrentState: ObservableObject {
        @Published var base = Look()
        @Published var active: Look?
    }
}

public extension Look {
    static let state = CurrentState()

    static func set(active: Look) {
        state.active = active
    }

    static var current: Look {
        state.active ?? state.base
    }
}
