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
    @State var showStream = false

    func onSave(look _: Look) {}

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                Spacer()
                    .frame(height: 66)
                SpecificationOverview(spec: Look.current.spec)
            }.edgesIgnoringSafeArea(.all)

            self.showStream ?
                StreamsView(stream: Look.stream(), onSave: self.onSave)
                : nil

            Column {
                Button(action: { self.showStream.toggle() }) {
                    Text("Lux Stream")
                        .lux
                        .style(.button)
                        .view
                }

                Spacer()
            }
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
