//
//  Stream+Photon.swift
//  MaxwellSpex
//
//  Created by Mark C. Maxwell on The New Lux
//  Copyright © 2020. All rights reserved.
//

public struct Photon: Codable {
    public enum DataType: UInt32 {
        case string = 1
        case image = 2
    }

    public enum Role: String, Codable {
        case applyLook
    }

    public var serverName: String
    public var role: Role
    public var metaId: String?
    public var payload: String = ""

    public init(serverName: String, look: Look) {
        self.serverName = serverName
        role = .applyLook
        lookPayload = look
    }
}

public extension Photon {
    var lookPayload: Look? {
        get {
            if let look: Look = try? Codec.object(fromJSON: payload) {
                return look
            }
            return nil
        }
        set {
            payload = newValue.asJSONString()
        }
    }
}
