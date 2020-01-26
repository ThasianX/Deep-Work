//
//  ProjectsLocalRepository.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation
import Combine

protocol ProjectsLocalRepository {
    func loadProjects() -> AnyPublisher<[Project], Never>
    func addProject(name: String) -> Project
    func getProject(name: String) -> [Project]
}

struct RealProjectsLocalRepository: ProjectsLocalRepository {
    func loadProjects() -> AnyPublisher<[Project], Never> {
        return Just(Project.allInOrder()).eraseToAnyPublisher()
    }
    
    func addProject(name: String) -> Project{
        return Project.createProject(name: name)
    }
    
    func getProject(name: String) -> [Project] {
        let predicate = NSPredicate(format: "name == %@", name)
        return CoreDataDataSource<Project>(predicate: predicate).fetchedObjects
    }
}
