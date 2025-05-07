

import Foundation

enum MeasurementOptions: String, CaseIterable, Identifiable {
    case none
    case oz
    case lb
    
    var id: Self { self }
}
