//
//  ContentView.swift
//  Demo
//
//  Created by Mark C Maxwell on 5/26/20.
//  Copyright © 2020 maxwell.design. All rights reserved.
//

import Lux
import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical) {
            SpecificationOverview(spec: Look.current.spec)
        }
    }
}

struct ContentViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView(.vertical) {
                SpecificationOverview(spec: Look.current.specLight)
            }
            ScrollView(.vertical) {
                SpecificationOverview(spec: Look.current.specDark)
            }
        }
    }
}
