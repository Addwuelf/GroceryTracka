//
//  SavedSettings+CoreDataClass.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 5/16/25.
//
//

import Foundation
import CoreData

@objc(SavedSettings)
public class SavedSettings: NSManagedObject {
    @NSManaged public var infos: [String]?
}
