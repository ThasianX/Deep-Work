//
//  ProjectService.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData

protocol ProjectService {
    func loadProjects() -> [Project]
    
    @discardableResult
    func addProject(name: String) -> Project
    
    @discardableResult
    func remove(project: Project) -> Project
    
    func load(name: String) -> Project?
    
    func projectDetails(for project: Project) -> ProjectDetails
    
    @discardableResult
    func addTask(name: String, duration: Double, measureOfSuccess: String, project: Project) -> Task
    
    func completeTask(task: Task, offsetTime: Double)
}

struct LocalProjectService: ProjectService {
    func loadProjects() -> [Project] {
        return Project.allInOrder()
    }
    
    func addProject(name: String) -> Project {
        return Project.createProject(name: name)
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
        var tasks = project.allTasks.sorted(by: { $0.createdAt > $1.createdAt })
        var currentTask: Task? = nil
        if let latestTask = tasks.first {
            currentTask = latestTask
            tasks.removeFirst()
        }
        
        return ProjectDetails(currentTask: currentTask, completedTasks: tasks)
    }
    
    func addTask(name: String, duration: Double, measureOfSuccess: String, project: Project) -> Task {
        return Task.createTask(name: name, duration: duration, measureOfSuccess: measureOfSuccess, project: project)
    }
    
    func completeTask(task: Task, offsetTime: Double = 0) {
        task.duration += offsetTime
        task.completed()
        if let session = deepWorkSession(for: task.project) {
            session.add(time: task.duration)
        } else {
            DeepWork.createSession(time: task.duration, project: task.project)
        }
    }
    
    func deepWorkSession(for project: Project) -> DeepWork? {
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end = cal.date(byAdding: .day, value: 1, to: Date())!
        return project.allDeepWorkSessions.first(where: { $0.date > start && $0.date < end })
    }
}
