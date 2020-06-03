//
//  Look+Provider.swift
//  Styling
//
//  Created by mark maxwell on 1/5/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

public protocol LookProvider {
    var look: Look { get }
}

public extension LookProvider {
    var look: Look {
        Look.current
    }
}
