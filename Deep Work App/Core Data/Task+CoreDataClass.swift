//
//  Task+CoreDataClass.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/20/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    class func allInOrder() -> [Task] {
        let datasource = CoreDataDataSource<Task>()
        return datasource.fetch()
    }
    
    #if DEBUG
    class func preview() -> Task {
        Task.createTask(name: "Write english essay", duration: 60, measureOfSuccess: "At least 1 page written", project: Project.createProject(name: "School"), complete: false)
    }
    #endif
    
    class func newTask() -> Task {
        Task(context: CoreData.stack.context)
    }
    
    @discardableResult
    class func createTask(name: String, duration: Double, measureOfSuccess: String, project: Project, complete: Bool) -> Task {
        let task = newTask()
        
        task.name = name
        task.createdAt = Date()
        task.duration = duration
        task.measureOfSucess = measureOfSuccess
        task.project = project
        task.complete = complete
        CoreData.stack.save()
        
        return task
    }
    
    public func update(name: String) {
        self.name = name
        CoreData.stack.save()
    }
    
    public func edit(duration: Double) {
        self.duration = duration
        CoreData.stack.save()
    }
    
    public func completed() {
        self.complete = true
        CoreData.stack.save()
    }
    
    public func delete() {
        CoreData.stack.context.delete(self)
    }
}
