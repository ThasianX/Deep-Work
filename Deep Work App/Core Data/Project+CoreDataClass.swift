//
//  Project+CoreDataClass.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/20/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Project)
public class Project: NSManagedObject {
    
    class func allInOrder() -> [Project] {
        let datasource = CoreDataDataSource<Project>()
        return datasource.fetch()
    }
    
    #if DEBUG
    class func previewProjects() -> [Project] {
        var projects = allInOrder()
        if projects.count > 0 {
            return projects
        } else {
            let project = createProject(name: "School")
            for _ in 0...3 {
                Task.createTask(name: "Write english essay", duration: 60, measureOfSuccess: "At least 1 page written", project: project, complete: true)
            }
            Task.createTask(name: "Write english essay", duration: 60, measureOfSuccess: "At least 1 page written", project: project, complete: false)
            
            projects.append(project)
            
            return projects
        }
    }
    #endif
    
    // MARK: CRUD
    public var completedTasks: [Task] {
        guard let tasks = self.tasks as? Set<Task> else {
            return []
        }
        return tasks.sorted { $0.createdAt < $1.createdAt }
    }
    
    class func newProject() -> Project {
        Project(context: CoreData.stack.context)
    }
    
    class func createProject(name: String) -> Project {
        let project = newProject()
        
        project.name = name
        project.createdAt = Date()
        project.timeSpent = 0
        project.archived = false
        CoreData.stack.save()
        
        return project
    }
    
    public func update(name: String) {
        self.name = name
        CoreData.stack.save()
    }
    
    public func add(time: Double) {
        self.timeSpent += time
        CoreData.stack.save()
    }
    
    public func archive() {
        self.archived.toggle()
        CoreData.stack.save()
    }
    
    public func delete() {
        CoreData.stack.context.delete(self)
    }
}
