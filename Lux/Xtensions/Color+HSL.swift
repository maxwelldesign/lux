
import SwiftUI

extension Color {
    func lighting(spec: SpecificationProtocol, at elevation: Look.Elevation) -> Color {
        uiColor().brightness(plus: spec.elevationBrightness(for: elevation)).paint
    }
}
