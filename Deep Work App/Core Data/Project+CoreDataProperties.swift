//
//  Project+CoreDataProperties.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/20/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData


extension Project: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var archived: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var name: String
    @NSManaged public var timeSpent: Double
    @NSManaged public var tasks: NSSet?
    @NSManaged public var deepWork: NSSet?
}

// MARK: Generated accessors for tasks
extension Project {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

// MARK: Generated accessors for deepWork
extension Project {

    @objc(addDeepWorkObject:)
    @NSManaged public func addToDeepWork(_ value: DeepWork)

    @objc(removeDeepWorkObject:)
    @NSManaged public func removeFromDeepWork(_ value: DeepWork)

    @objc(addDeepWork:)
    @NSManaged public func addToDeepWork(_ values: NSSet)

    @objc(removeDeepWork:)
    @NSManaged public func removeFromDeepWork(_ values: NSSet)

}
