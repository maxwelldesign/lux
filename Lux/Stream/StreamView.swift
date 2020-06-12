//
//  StreamsView.swift
//  MaxwellSpex
//
//  Created by Mark C. Maxwell on The New Lux
//  Copyright © 2020. All rights reserved.
//

import SwiftUI

public struct StreamsView: View {
    @ObservedObject var stream: LuxStream
    var onSaveLook: (Look) -> Void

    public init(stream: LuxStream, onSave: @escaping (Look) -> Void) {
        onSaveLook = onSave
        self.stream = stream
    }

    var helpText: String {
        switch stream.config.role {
        case .none:
            return "Pair two or more nearby devices and tweak Lux in realtime"
        case .tuning:
            return "Tune nearby streams and recieve Lux in realtime"
        case .streaming:
            return "Stream to nearby tuners and tweak Lux in realtime"
        }
    }

    public var body: some View {
        Column {
            StreamViewHeader(stream: self.stream)

            Column {
                Group {
                    self.stream.config.shouldConnect ?
                        Group {
                            StreamViewConnectedContent(stream: self.stream, onSaveLook: self.onSaveLook)
                        }.lux.view
                        :
                        VStack {
                            Spacer()
                            HStack {
                                Group {
                                    Image(systemName: "antenna.radiowaves.left.and.right")
                                        .scaleEffect(self.stream.config.role == .streaming ? 2.0 : 1.0)
                                        .animation(.easeInOut)

                                    Image(systemName: "radiowaves.right")
                                        .scaleEffect(self.stream.config.role == nil ? 2.0 : 1.0)
                                        .animation(.easeInOut)

                                    Image(systemName: "waveform.circle.fill")
                                        .scaleEffect(self.stream.config.role == .tuning ? 2.0 : 1.0)
                                        .animation(.easeInOut)
                                }
                                .lux
                                .tweak(.largeTitleLayout)
                                .style(.iconLarge, .text)
                                .view
                            }
                            Text(self.helpText)
                                .bold()
                                .lux
                                .tweak(.headlineLayout)
                                .style(.paragraphBlock)
                                .view
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .lux
                        .feature(.inactiveOpacity)
                        .view
                }
                .lux
                .style(.layoutElement)
                .view

                Spacer()

                self.stream.config.role != nil ?
                    StreamPlayButton(stream: self.stream)
                    .lux
                    .style(.layoutElement)
                    .view
                    : nil
            }
            .lux
            .style(.layoutBlock)
            .view

            StreamViewTabs(stream: self.stream)
        }
        .lux
        .style(.panel)
        .view
    }
}

public struct StreamsViewStreamsList: View {
    @ObservedObject var stream: LuxStream

    func select(server name: String) {
        stream.config.serverName = name
    }

    public var body: some View {
        Column {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .lux
                    .tweak(.canvasSurface)
                    .style(.iconLarge)
                    .view
                Text("Tunning")
            }
            .lux
            .tweak(.canvasSurface, .titleLayout)
            .style(.paragraph)
            .feature(.secondaryOpacity)
            .view

            List {
                ForEach(self.stream.streamNames, id: \.self) { (name: String) in
                    Button(action: { self.select(server: name) }) {
                        Row {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .lux
                                .tweak(.canvasSurface)
                                .style(.iconLarge)
                                .view

                            Text(name)
                                .lux
                                .tweak(.canvasSurface)
                                .style(.icon)
                                .view
                        }
                        .lux
                        .tweak(.normalSurface, .titleLayout)
                        .feature(.flexibleWidth)
                        .style(.buttonLarge)
                        .view
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}

public struct StreamViewHeader: View {
    @ObservedObject var stream: LuxStream

    func configRole(_ role: LuxStream.Role?) {
        stream.config.shouldConnect = false
        stream.config.role = role
    }

    public var body: some View {
        Row {
            Text("Lux Stream")
                .lux
                .tweak(.largeTitleLayout)
                .style(.paragraphBlock)
                .view
            Spacer()

            Spacer()

            Image(systemName: "antenna.radiowaves.left.and.right")
                .lux
                .tweak(.largeTitleLayout)
                .style(.icon, .paragraphBlock)
                .view
        }
        .lux
        .style(.bar)
        .feature(.inactiveOpacity)
        .view
    }
}

public struct StreamViewConnectedContent: View {
    @ObservedObject var stream: LuxStream
    @State var saved = false
    var onSaveLook: (Look) -> Void

    var infoText: String {
        switch stream.config.role {
        case .none:
            return "Off"
        case .tuning:
            return stream.config.serverName ?? "No Server"
        case .streaming:
            return stream.streamingLook.name
        }
    }

    var defaultLook: Look {
        let look = Look()
        look.name = stream.config.serverName ?? "No Stream"
        return look
    }

    var tunedLook: Look {
        stream.tunedLook ?? defaultLook
    }

    func sync() {
        stream.broadcastLook()
    }

    func saveTunedLook() {
        if canSave, let look = stream.tunedLook?.clone() {
            onSaveLook(look)
            saved = true
        }
    }

    var canSave: Bool {
        saved == false && hasTunedLook
    }

    var hasTunedLook: Bool {
        stream.tunedLook != nil
    }

    public var body: some View {
        Group {
            self.stream.needsSeverName ?
                StreamsViewStreamsList(stream: self.stream)
                .lux
                .tweak(.canvasSurface)
                .style(.panel)
                .view
                : nil

            self.stream.serverNameIsSet ?
                Group {
                    self.stream.tunedLook != nil ?
                        HStack {
                            Spacer()
                            Text("Tuning")
                            Text(self.stream.config.serverName ?? self.stream.tunedLook!.name)
                            Spacer()
                        }
                        .lux
                        .tweak(.titleLayout)
                        .style(.paragraph)
                        .feature(.inactiveOpacity)
                        .view
                        : nil

                    Row {
                        LookDisplay(
                            look: self.tunedLook,
                            onEdit: {}
                        )
                    }

                    Row {
                        self.canSave ?
                            Button(action: self.saveTunedLook) {
                                HStack {
                                    Image(systemName: "square.and.arrow.down")
                                    Text("Save \(self.stream.tunedLook?.name ?? "Look")")
                                }
                                .lux
                                .style(.buttonLarge, .text)
                                .feature(.inactiveOpacity)
                                .view
                            }.lux.view

                            :
                            self.hasTunedLook ?
                            Button(action: { self.saved = false }) {
                                HStack {
                                    Image(systemName: "checkmark")
                                    Text("Saved...")
                                }
                                .lux
                                .style(.paragraph, .text)
                                .feature(.inactiveOpacity)
                                .view
                            }.lux.view

                            : Text("Waiting for updates...")
                            .lux
                            .style(.paragraph, .text)
                            .feature(.inactiveOpacity)
                            .view

                        Spacer()
                    }

                } : nil

            self.stream.config.role == .streaming ?
                Group {
                    HStack {
                        Spacer()
                        Text("Streaming")
                        Text(self.stream.streamingLook.name)
                        Spacer()
                    }
                    .lux
                    .tweak(.titleLayout)
                    .style(.paragraph)
                    .feature(.inactiveOpacity)
                    .view

                    Row {
                        LookDisplay(
                            look: self.stream.streamingLook,
                            onEdit: {}
                        )
                    }

                    Row {
                        Spacer()
                            .lux
                            .feature(.flexibleWidth)
                            .view

                        Button(action: self.sync) {
                            Image(systemName: "arrow.3.trianglepath")
                                .lux
                                .style(.buttonLarge, .text)
                                .feature(.inactiveOpacity)
                                .view
                        }
                    }
                } : nil
        }
    }
}

public struct StreamViewTabs: View {
    @ObservedObject var stream: LuxStream

    func configRole(_ role: LuxStream.Role?) {
        stream.config.shouldConnect = false
        stream.config.role = role
    }

    public var body: some View {
        Row {
            Group {
                Button(action: { self.configRole(.streaming) }) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                    Text("Stream")
                }
                .lux
                .unless(self.stream.config.role == .streaming) { $0.feature(.inactiveOpacity) }
                .view

                Button(action: { self.configRole(nil) }) {
                    Image(systemName: "waveform.circle")
                    Text("Off")
                }
                .lux
                .unless(self.stream.config.role == nil) { $0.feature(.inactiveOpacity) }
                .view

                Button(action: { self.configRole(.tuning) }) {
                    Image(systemName: "waveform.circle.fill")
                    Text("Tune")
                }
                .lux
                .unless(self.stream.config.role == .tuning) { $0.feature(.inactiveOpacity) }
                .view
            }
            .lux
            .tweak(.headlineLayout)
            .feature(.fixedSize)
            .style(.text, .layoutBlock)
            .feature(.flexibleWidth)
            .view
        }
        .lux
        .style(.bar)
        .view
    }
}

public struct StreamPlayButton: View {
    @ObservedObject var stream: LuxStream

    func configStream(look: Look?) {
        stream.preferredLook = look
    }

    func toggleConnection() {
        stream.config.shouldConnect = !stream.config.shouldConnect
    }

    var iconPlay: String {
        stream.config.shouldConnect ? "play.fill" : "play"
    }

    var textfieldSurface: Lux.Tweak {
        switch stream.config.role {
        case .none:
            return .canvasSurface
        case .tuning:
            return .normalSurface
        case .streaming:
            return .activeSurface
        }
    }

    public var body: some View {
        Button(action: self.toggleConnection) {
            HStack {
                Group {
                    Circle()
                        .fill(self.stream.status.color)
                        .frame(width: self.lux.spec.padding.base, height: self.lux.spec.padding.base, alignment: .trailing)
                }
                .lux
                .tweak(.captionLayout)
                .style(.paragraph)
                .feature(.inactiveOpacity)
                .view
                .multilineTextAlignment(.trailing)
                Image(systemName: self.iconPlay)
            }
            .lux
            .tweak(.activeSurface, .titleLayout)
            .feature(.flexibleWidth)
            .style(.buttonLarge, .text)
            .unless(self.stream.config.shouldConnect) { $0.feature(.inactiveOpacity) }
            .view
        }
    }
}
