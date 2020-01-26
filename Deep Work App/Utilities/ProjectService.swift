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
    
    func removeProject(project: Project)
    
    func load(name: String) -> Project
}

struct LocalProjectService: ProjectService {
    func loadProjects() -> [Project] {
        Project.allInOrder()
    }
    
    func addProject(name: String) -> Project {
        Project.createProject(name: name)
    }
    
    func removeProject(project: Project) {
        project.delete()
    }
    
    func load(name: String) -> Project {
        let predicate = NSPredicate(format: "name == %@", name)
        let fetched = CoreDataDataSource<Project>(predicate: predicate).fetchedObjects
        
        return fetched.first ?? .stub
    }
}
