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
        var projects = [Project]()
        let project1 = createProject(name: "School")
        for _ in 0...3 {
            Task.createTask(name: "Write english essay", duration: 60, measureOfSuccess: "At least 1 page written", project: project1)
        }
        projects.append(project1)
        
        let project2 = createProject(name: "Personal")
        for _ in 0...3 {
            Task.createTask(name: "Work on personal website", duration: 60, measureOfSuccess: "At least 1 screen finished", project: project2)
        }
        projects.append(project2)
        
        let project3 = createProject(name: "Fitness")
        for _ in 0...3 {
            Task.createTask(name: "Go to the gym", duration: 60, measureOfSuccess: "45 minutes in the gym", project: project3)
        }
        projects.append(project3)
        
        return projects
    }
    #endif
    
    // MARK: CRUD
    public var allTasks: [Task] {
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
