//
//  File.swift
//  MaxwellSpex
//
//  Created by Mark C. Maxwell on The New Lux
//  Copyright © 2020. All rights reserved.
//

import Combine
import SwiftUI

public extension LuxStream {
    static var DefaultServer = "LUX"

    enum Role: String, Hashable {
        case streaming
        case tuning
    }

    struct Config {
        public var name: String = "Lux"
        public var role: Role?
        public var shouldConnect = false
        public var serverName: String? = LuxStream.DefaultServer

        public var configHash: String {
            "\(shouldConnect)\(String(describing: role?.rawValue))\(name)"
        }

        public var streamName: String {
            String(name.alphanumeric.lowercased().prefix(13))
        }
    }
}

public class LuxStream: ObservableObject {
    public enum Status: String {
        case disconnected
        case connecting
        case connected

        public var color: Color {
            switch self {
            case .disconnected:
                return Color.red
            case .connecting:
                return Color.yellow
            case .connected:
                return Color.green
            }
        }
    }

    static let refreshDelay = 0.750
    static let LuxStreamServiceTag = "01"

    public var status: Status = .disconnected {
        // Note: Patch to prevent compilation error with @Publisher an enum
        didSet {
            statusString = status.rawValue
        }
    }

    @Published public var statusString: String = ""

    @Published public var preferredLook: Look?
    @Published public var tunedLook: Look?
    @Published public var streamNames: [String] = []

    public var multiPeer: MultiPeer?
    public var currenLookObserver: AnyCancellable?
    public var connectedConfig: Config?
    public var config = Config() {
        didSet {
            commitConnection()
        }
    }

    public init() {}

    public var objectWillChangePublisher: ObjectWillChangePublisher {
        objectWillChange
    }
}

public extension LuxStream {
    var serviceType: String {
        "\(Self.LuxStreamServiceTag)\(config.streamName)"
    }
}

public extension LuxStream {
    func commitConnection() {
        objectWillChange.send()

        config.shouldConnect ?
            connectIntent()
            : disconnectNow()
    }

    func connectIntent() {
        guard connectedConfig?.configHash != config.configHash else { return }
        connectedConfig = config
        connect()

        switch config.role {
        case .streaming:
            observeCurrentLook()
            broadcastLook()
        case .tuning:
            stopObservingLook()
        default:
            break
        }

        status = .connecting
    }

    func updateStatus() {
        status = config.shouldConnect && multiPeer?.isConnected == true ? .connected : .disconnected
    }

    func connect() {
        disconnectNow()

        multiPeer = MultiPeer()
        multiPeer?.delegate = self
        multiPeer?.initialize(serviceType: config.streamName)

        multiPeer?.autoConnect()
    }

    func disconnectNow() {
        multiPeer?.disconnect()
        multiPeer = nil
        connectedConfig = nil
        tunedLook = nil
        status = .disconnected
    }
}

public extension LuxStream {
    func stopObservingLook() {
        currenLookObserver?.cancel()
        currenLookObserver = nil
    }

    func observeCurrentLook() {
        currenLookObserver?.cancel()
        currenLookObserver = Look.state.objectWillChange
            .throttle(for: .seconds(Self.refreshDelay), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                self?.broadcastLook()
            }
    }
}

public extension LuxStream {
    var streamServerName: String {
        config.serverName ?? Self.DefaultServer
    }
}

public extension LuxStream {
    func broadcastLook() {
        if let preferredLook = preferredLook {
            return stream(Photon(serverName: streamServerName, look: preferredLook))
        }
        stream(Photon(serverName: streamServerName, look: Look.current))
    }
}

public extension LuxStream {
    func stream(_ photon: Photon) {
        guard
            let multiPeer = multiPeer,
            multiPeer.isConnected == true
        else {
            return
        }
        guard config.role == .streaming else {
            return
        }

        multiPeer
            .send(object: photon,
                  type: Photon.DataType.string.rawValue)
    }

    func tune(_ photon: Photon) {
        guard config.role == .tuning else {
            return
        }

        guard photon.serverName == config.serverName else {
            return
        }

        switch photon.role {
        case .applyLook:
            tunedLook = photon.lookPayload
        }
    }
}

extension LuxStream: MultiPeerDelegate {
    public func multiPeer(didReceive packet: MultiPeer.Packet) {
        updateStatus()

        switch packet.type {
        case Photon.DataType.string.rawValue:

            guard let stringData = String(data: packet.data, encoding: .utf8) else {
                return
            }
            if let photon: Photon = try? Codec.object(fromJSON: stringData) {
                return tune(photon)
            }
            assert(false, "unhandled data type")
            return
        case Photon.DataType.image.rawValue:
            //          let image = UIImage(data: data)
            // do something with the received UIImage
            break
        default:
            assert(false, "unhandled data type")
            return
        }
    }

    public func multiPeer(connectedDevicesChanged names: [String]) {
        streamNames = names
        updateStatus()
    }
}

public extension LuxStream {
    var icon: String {
        switch config.role {
        case .none:
            return "waveform.circle"
        case .tuning:
            return "waveform.circle.fill"
        case .streaming:
            return "antenna.radiowaves.left.and.right"
        }
    }
}

public extension LuxStream {
    var streamingLook: Look {
        preferredLook ?? Look.current
    }

    var hasPreferredLook: Bool {
        preferredLook != nil
    }

    var needsSeverName: Bool {
        config.role == .tuning && config.serverName == nil
    }

    var serverNameIsSet: Bool {
        config.role == .tuning && config.serverName != nil
    }

    var isDisconnected: Bool {
        status == .disconnected
    }

    var isConnected: Bool {
        status == .connected
    }
}
