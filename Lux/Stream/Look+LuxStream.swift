//
//  Lux+LuxStream.swift
//  Lux
//
//  Created by Mark Maxwell on the New LUX
//  Copyright © 2020 maxwell.design. All rights reserved.
//
import Combine
import UIKit

public extension Look {
    static var _stream: LuxStream?
    static var _streamObservable: AnyCancellable?

    static func stream() -> LuxStream {
        _stream = _stream ?? LuxStream()
        return _stream!
    }

    static func disconnectStream() {
        _streamObservable?.cancel()
        _streamObservable = nil

        _stream?.disconnectNow()
        _stream = nil
    }
}

public extension Look {
    static func streaming(to server: String = LuxStream.DefaultServer) {
        disconnectStream()

        let channel = stream()

        channel.config.serverName = server
        channel.config.role = .streaming
        channel.config.shouldConnect = true
    }

    static func tuning(from server: String = LuxStream.DefaultServer) {
        disconnectStream()

        let channel = stream()

        channel.config.serverName = server
        channel.config.role = .tuning
        channel.config.shouldConnect = true

        _streamObservable = channel.objectWillChange
            .throttle(for: .milliseconds(250), scheduler: RunLoop.main, latest: true)
            .sink { _ in

                guard let look = Self._stream?.tunedLook else { return }
                Look.set(active: look)
            }
    }
}
