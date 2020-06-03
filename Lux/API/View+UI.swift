//
//  Styling+ViewUI.swift
//  Styling
//
//  Created by mark maxwell on 1/7/20.
//  Copyright © 2020 eonflux. All rights reserved.
//

import SwiftUI

public struct Toolbar<Content: View>: View {
    let viewBuilder: () -> Content
    let trait: Trait

    public init(trait: Trait = Trait(), @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.trait = trait
        self.viewBuilder = viewBuilder
    }

    public var body: some View {
        Row {
            self.viewBuilder()
        }
        .lux
        .trait(trait)
        .style(.bar, .typography)
        .feature(.cornerRadius, .hairlinePadding)
        .view
    }
}

public struct Paragraph<Content: View>: View {
    let trait: Trait
    let viewBuilder: () -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?

    var textAlignment: TextAlignment {
        switch alignment {
        case .trailing:
            return .trailing
        case .center:
            return .center
        default:
            return .leading
        }
    }

    public init(_ trait: Trait = Trait(), alignment: HorizontalAlignment = .leading, spacing: CGFloat? = 0, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.trait = trait
        self.viewBuilder = viewBuilder
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            self.viewBuilder()
        }
        .lux
        .trait(trait)
        .style(.multiParagraphBlock)
        .view
        .multilineTextAlignment(textAlignment)
    }
}

public struct ParagraphGroup<Content: View>: View {
    let trait: Trait
    let viewBuilder: () -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?

    public init(_ trait: Trait = Trait(), alignment: HorizontalAlignment = .leading, spacing: CGFloat? = 0, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.trait = trait
        self.viewBuilder = viewBuilder
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        Paragraph {
            Group {
                self.viewBuilder()
            }
            .lux
            .trait(self.trait)
            .style(.paragraph)
            .view
        }
    }
}

public struct Panel<Content: View>: View {
    let viewBuilder: () -> Content
    let trait: Trait

    public init(_ trait: Trait = Trait(), @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.trait = trait
        self.viewBuilder = viewBuilder
    }

    public var body: some View {
        Column {
            self.viewBuilder()
        }
        .lux
        .trait(trait)
        .style(.panel)
        .view
    }
}

public struct Card<Content: View>: View {
    let viewBuilder: () -> Content
    let trait: Trait

    public init(_ trait: Trait = Trait(), @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.trait = trait
        self.viewBuilder = viewBuilder
    }

    public var body: some View {
        Column {
            self.viewBuilder()
        }
        .lux
        .trait(trait)
        .style(.card)
        .view
    }
}

public struct Container<Content: View>: View {
    let viewBuilder: () -> Content

    public init(@ViewBuilder viewBuilder: @escaping () -> Content) {
        self.viewBuilder = viewBuilder
    }

    public var body: some View {
        self.viewBuilder().lux.style(.paragraph).view
    }
}

public struct Column<Content: View>: View {
    let viewBuilder: () -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = 0, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.viewBuilder = viewBuilder
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            self.viewBuilder()
        }
    }
}

public struct Row<Content: View>: View {
    let viewBuilder: () -> Content
    let alignment: VerticalAlignment
    let spacing: CGFloat?

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = 0, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.viewBuilder = viewBuilder
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            self.viewBuilder()
        }
    }
}

// MARK: Geometry Readers

public struct PanelGeometry<Content: View>: View {
    let viewBuilder: (GeometryProxy) -> Content

    public init(@ViewBuilder viewBuilder: @escaping (GeometryProxy) -> Content) {
        self.viewBuilder = viewBuilder
    }

    public var body: some View {
        GeometryReader { proxy in
            Panel {
                self.viewBuilder(proxy)
            }
        }
    }
}

public struct RowGeometry<Content: View>: View {
    let viewBuilder: (GeometryProxy) -> Content
    let alignment: VerticalAlignment
    let spacing: CGFloat?

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder viewBuilder: @escaping (GeometryProxy) -> Content) {
        self.viewBuilder = viewBuilder
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        GeometryReader { proxy in
            Row(alignment: self.alignment, spacing: self.spacing) {
                self.viewBuilder(proxy)
            }
        }
    }
}

public struct ColumnGeometry<Content: View>: View {
    let viewBuilder: (GeometryProxy) -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder viewBuilder: @escaping (GeometryProxy) -> Content) {
        self.viewBuilder = viewBuilder
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        GeometryReader { proxy in
            Column(alignment: self.alignment, spacing: self.spacing) {
                self.viewBuilder(proxy)
            }
        }
    }
}

struct CustomRotationEffect3D: GeometryEffect {
    var offsetValue: CGFloat // 0...1
    var perspective: CGFloat // 0...1

    var animatableData: Double {
        get { offsetValue.doubleValue }
        set { offsetValue = CGFloat(newValue) }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        var transform3d = CATransform3DIdentity
        transform3d.m34 = 1.0 / perspective // setting perspective projection
        //        transform3d = CATransform3DRotate(transform3d, CGFloat(angle), 0, 1, 0)

        transform3d = CATransform3DTranslate(transform3d, -size.width / 2.0, -size.height / 2.0, 0) // shifting anchor of rotation
        transform3d = CATransform3DTranslate(transform3d, 0.0, 0.0, CGFloat(offsetValue)) // shifting anchor of rotation

        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0)) // shifting back in screen space

        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct Example: View {
    var body: some View {
        Text("Hello World")
    }
}

struct ExamplePreview: PreviewProvider {
    static var previews: some View {
        Example()
    }
}
