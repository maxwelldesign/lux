//
//  Look+CodableHelpers.swift
//  Styling
//
//  Created by mark maxwell on 1/5/20.
//  Copyright © 2020 eonflux. All rights reserved.
//
import SwiftUI

struct CodableFont: Codable {
    let size: CGFloat
    let name: String
    var descriptorData: Data?

    init(_ font: UIFont) {
        do {
            descriptorData = try NSKeyedArchiver.archivedData(withRootObject: font.fontDescriptor, requiringSecureCoding: false)
        } catch {
            assert(false, "unexpected")
        }

        size = font.pointSize
        name = font.familyName
    }

    var font: UIFont {
        do {
            if
                let descriptorData = descriptorData,
                let fontDescriptor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIFontDescriptor.self, from: descriptorData)
            {
                return UIFont(descriptor: fontDescriptor, size: size)
            }
        } catch {
            assert(false, "unexpected")
        }

        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    enum CodingKeys: String, CodingKey {
        case size
        case name
        case descriptor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        descriptorData = try container.decode(Data.self, forKey: .descriptor)
        size = try container.decode(CGFloat.self, forKey: .size)
        name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(descriptorData, forKey: .descriptor)
        try container.encode(size, forKey: .size)
        try container.encode(name, forKey: .name)
    }
}

struct CodableColor: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(_ uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }

    init(_ color: Color) {
        color.uiColor().getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
