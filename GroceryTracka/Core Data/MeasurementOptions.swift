

import Foundation

enum MeasurementOptions: String, CaseIterable, Identifiable {
    case none
    case bunch
    case chopped
    case clove
    case cloves
    case cup
    case cups
    case dash
    case fillet
    case florets
    case gal
    case g
    case grams
    case half
    case handful
    case head
    case kg
    case l
    case lb
    case mg
    case milliliters
    case ml
    case oz
    case packet
    case piece
    case pinch
    case pint
    case quart
    case slice
    case sliced
    case slices
    case stick
    case tbs
    case tbsp
    case tablespoon
    case tablespoons
    case teaspoons
    case tsp
    case whole
    case unknown

    var id: Self { self }
}
