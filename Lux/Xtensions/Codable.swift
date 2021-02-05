//
//  Codable+JSON.swift
//  swytUI
//
//  Created by Mark Maxwell on 12/11/19.
//  Copyright © 2019 eonflux. All rights reserved.
//

import UIKit

extension Encodable {
    func asJSONString() -> String {
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(self)
        return String(data: data!, encoding: .utf8)!
    }
}

extension Encodable {
    func asJSONObject() -> [String: Any] {
        do {
            let data = asJSONString().data(using: .utf8)!
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]

        } catch let error as NSError {
            print(error)
        }

        return [:]
    }
}

import SwiftUI
import UIKit

typealias JSONString = String

enum Codec {
    static func json<T: Codable>(from object: T) throws -> JSONString {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(object)
        return String(data: data, encoding: .utf8)!
    }

    static func object<T: Codable>(fromJSON json: JSONString) throws -> T {
        let jsonDecoder = JSONDecoder()
        let data = json.data(using: .utf8)
        let result = try jsonDecoder.decode(T.self, from: data!)
        return result
    }

    static func dictionary<T: Codable>(from object: T) throws -> [String: Any?] {
        let data = try JSONEncoder().encode(object)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

        return dictionary!
    }

    static func jsonObject(from string: JSONString) -> [String: Any] {
        do {
            let data = string.data(using: .utf8)!
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]

        } catch let error as NSError {
            print(error)
        }

        return [:]
    }

    static func json(fromJSONObject object: AnyObject) -> String? {
        do {
            let data1 = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            return String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string

        } catch let error as NSError {
            print(error)
        }

        return ""
    }
}
