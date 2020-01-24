//
//  Task+CoreDataProperties.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/20/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData


extension Task: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
    @NSManaged public var duration: Double
    @NSManaged public var measureOfSucess: String
    @NSManaged public var project: Project
    @NSManaged public var complete: Bool

}
