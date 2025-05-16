//
//  SavedSettings+CoreDataProperties.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 5/16/25.
//
//

import Foundation
import CoreData


extension SavedSettings {
    var wrappedInfos: [String] {
           get {
               infos ?? []
           }
           set {
               infos = newValue
           }
       }
}


