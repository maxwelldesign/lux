//
//  File.swift
//
//
//  Created by mark maxwell on 4/19/20.
//

import Foundation

extension Lux {
    public struct Style: Codable, Hashable {
        public var tweaks: [Tweak]
        public var features: [Feature]
    }
}
