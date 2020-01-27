//
//  ProjectService.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

protocol ProjectService {
    func loadProjects() -> [Project]
    
    @discardableResult
    func addProject(name: String) -> Project
    
    func remove(project: Project) -> Project
    
    func load(name: String) -> Project?
    
    func projectDetails(for project: Project) -> ProjectDetails
}

struct LocalProjectService: ProjectService {
    func loadProjects() -> [Project] {
        Project.allInOrder()
    }
    
    func addProject(name: String) -> Project {
        Project.createProject(name: name)
    }
    
    func remove(project: Project) -> Project{
        return project.delete()
    }
    
    func load(name: String) -> Project? {
        let predicate = NSPredicate(format: "name == %@", name)
        let fetched = CoreDataDataSource<Project>(predicate: predicate).fetchedObjects
        
        return fetched.first ?? nil
    }
    
    func projectDetails(for project: Project) -> ProjectDetails {
        var tasks = project.allTasks
        var currentTask: Task? = nil
        if let latestTask = tasks.first {
            currentTask = latestTask
            tasks.removeFirst()
        }
        
        return ProjectDetails(currentTask: currentTask, completedTasks: tasks)
    }
}
