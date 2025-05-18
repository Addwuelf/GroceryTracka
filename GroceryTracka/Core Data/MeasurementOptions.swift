

import Foundation

enum MeasurementOptions: String, CaseIterable, Identifiable {
    case none
    case oz
    case lb
    case kg
    case g
    case grams
    case mg
    case ml
    case milliliters
    case l
    case tsp
    case teaspoons
    case tbsp
    case tablespoon
    case tablespoons
    case cup
    case cups
    case pint
    case quart
    case gal
    case dash
    case pinch
    case whole
    case slice
    case sliced
    case slices
    case handful
    case bunch
    case stick
    case clove
    case cloves
    case half
    case florets
    case piece
    case fillet
    case packet
    case head
    case unknown

    var id: Self { self }
}
