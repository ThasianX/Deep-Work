//
//  DeepWork+CoreDataProperties.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData


extension DeepWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeepWork> {
        return NSFetchRequest<DeepWork>(entityName: "DeepWork")
    }

    @NSManaged public var date: Date
    @NSManaged public var time: Double
    @NSManaged public var project: Project

}
