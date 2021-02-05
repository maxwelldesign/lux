//
//  File.swift
//
//
//  Created by mark maxwell on 4/19/20.
//

import SwiftUI
import UIKit

extension UIFont.TextStyle: Codable {}

extension Edge.Set: Codable {}
extension Look.Layout: Hashable {}

public extension Look {
    typealias Layout = UIFont.TextStyle

    enum Surface: String, Codable, Hashable {
        case canvas
        case normal
        case accent
        case active

        public var displayName: String {
            rawValue.capitalized
        }
    }

    enum Priority: String, Codable {
        case primary
        case secondary
        case tertiary

        public func specName(numeric: Bool = true) -> String {
            switch self {
            case .primary:
                return numeric ? "1" : "A"
            case .secondary:
                return numeric ? "2" : "B"
            case .tertiary:
                return numeric ? "3" : "C"
            }
        }
    }

    enum FontMix: String, Codable, Equatable {
        case byPriority
        case mixed
    }

    enum Elevation: String, Codable, Equatable {
        case shadow
        case below3x
        case below2x
        case below
        case normal
        case above
        case above2x
        case above3x
        case highlight

        public var complementary: Elevation {
            switch self {
            case .shadow:
                return .highlight
            case .below3x:
                return .above3x
            case .below2x:
                return .above2x
            case .below:
                return .above
            case .normal:
                return .normal
            case .above:
                return .below
            case .above2x:
                return .below2x
            case .above3x:
                return .below3x
            case .highlight:
                return .shadow
            }
        }

        public var value: CGFloat {
            switch self {
            case .shadow:
                return -4
            case .below3x:
                return -3
            case .below2x:
                return -2
            case .below:
                return -1
            case .normal:
                return 0
            case .above:
                return 1
            case .above2x:
                return 2
            case .above3x:
                return 3
            case .highlight:
                return 4
            }
        }
    }
}
