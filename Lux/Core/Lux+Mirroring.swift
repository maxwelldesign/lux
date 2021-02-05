//
//  Styling+LUX+UIKit.swift
//  Styling
//
//  Created by mark maxwell on 2/16/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class UIMirroringCoordinator: UIHostingController<AnyView> {
    weak var uiView: UIView?

    var hierarchyOberver: AnyCancellable?
    var superviewOberver: AnyCancellable?

    public init(_ uiView: UIView) {
        self.uiView = uiView

        let rootView = ViewMirror(uiView: uiView, id: Look.current.hashValue).anyView()
        super.init(rootView: rootView)

        setupView()
        mirrorLayoutConstraints()
        setupObservers()
    }

    var parentView: UIView? {
        uiView?.superview
    }

    func setupView() {
        view.tag = Manager.mirrorTag
        view.backgroundColor = .clear
    }

    func mirrorLayoutConstraints() {
        guard let uiView = uiView else {
            assert(false, "required")
            return
        }

        guard let parentView = parentView else {
            return
        }

        parentView.insertSubview(view, aboveSubview: uiView)
//        view.snp.remakeConstraints { make in
//            make.edges.equalTo(uiView)
//            make.margins.equalTo(uiView)
//        }

        view.translatesAutoresizingMaskIntoConstraints = false

        view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0).isActive = true
    }

    func setupObservers() {
        superviewOberver = uiView?.publisher(for: \.superview).sink { _ in
            self.syncLayoutConstraints()
        }

        hierarchyOberver = parentView?.publisher(for: \.subviews).sink { _ in
            self.syncLayoutConstraints()
        }
    }

    func syncRootView() {
        guard let uiView = uiView else { return }
        rootView = ViewMirror(uiView: uiView, id: Look.current.hashValue).anyView()
    }

    func syncLayoutConstraints() {
        guard let uiView = uiView else { return }

        if view.superview != uiView.superview {
            mirrorLayoutConstraints() // TODO: check if it works
        }
    }

    @available(*, unavailable)
    @objc dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIMirroringCoordinator {
    enum Manager {
        static var mirrorTag: Int {
            3 * 6 * 9 * 13
        }

        static var mirrors: [UIView: UIMirroringCoordinator] = [:]
        static func setMirror(_ mirror: UIMirroringCoordinator, for uiView: UIView) {
            mirrors[uiView] = mirror
        }

        static func getMirror(for uiView: UIView?) -> UIMirroringCoordinator? {
            guard let uiView = uiView else { return nil }
            return mirrors[uiView]
        }

        @discardableResult
        static func mirror(for uiView: UIView) -> UIMirroringCoordinator {
            if let mirror = Self.getMirror(for: uiView) {
                mirror.syncRootView()
                return mirror
            }

            return makeMirror(for: uiView)
        }

        static func mirrorView(for uiView: UIView?) -> UIView? {
            uiView?.superview?.subviews.filter { $0.tag == Self.mirrorTag }.first
        }

        static func makeMirror(for uiView: UIView) -> UIMirroringCoordinator {
            let mirror = getMirror(for: uiView) ?? UIMirroringCoordinator(uiView)
            Self.setMirror(mirror, for: uiView)
            return mirror
        }

        static func sync(_ uiView: UIView, _ view: AnyView) {
            guard
                let mirror = Self.getMirror(for: uiView)
            else { return }

            mirror.rootView = view
        }
    }
}

struct ViewMirror: UIViewRepresentable {
    var uiView: UIView
    var id: Int = 0
    func makeUIView(context _: Context) -> UIView {
        uiView
    }

    func updateUIView(_ uiView: UIView, context _: Context) {
        uiView.layoutIfNeeded()
    }
}
