//
//  Look+Init.swift
//  Lux
//
//  Created by Mark Maxwell on the New LUX
//  Copyright © 2020 maxwell.design. All rights reserved.
//

extension Look {
    enum InitError: Error {
        case invalidData
    }

    public static func set(data64: String) throws {
        let json = data64.base64Decoded()
        guard let look: Look = try Codec.object(fromJSON: json) else {
            throw InitError.invalidData
        }
        Look.current.data = look.data
    }
}
