//
//  HomeViewModel.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct HomeState {
    @UserDefault(Constants.UserDefaults.currentProjectName, defaultValue: "")
    var currentProjectName: String
    
    var projects: [Project]
    
    var currentProject: Project?
    var projectDetails: ProjectDetails?
}

enum HomeInput {
    case setCurrentProject(String)
    case addProject(String)
    case deleteProject(Project)
}

class HomeViewModel: ViewModel {
    @Published var state: HomeState
    
    private let projectService: ProjectService
    
    init(projectService: ProjectService) {
        self.projectService = projectService
        self.state = HomeState(
            projects: projectService.loadProjects(),
            currentProject: nil,
            projectDetails: nil)
        self.state.currentProject = projectService.load(name: state.currentProjectName)
        if let currentProject = state.currentProject {
            self.state.projectDetails = projectService.projectDetails(for: currentProject)
        }
    }
    
    func fetchProjects() -> [Project] {
        projectService.loadProjects()
    }
    
    func trigger(_ input: HomeInput) {
        switch input {
        case let .setCurrentProject(name):
            state.currentProjectName = name
            
        case let .addProject(name):
            let project = projectService.addProject(name: name)
            state.projects = fetchProjects()
            trigger(.setCurrentProject(project.name))
            
        case let .deleteProject(project):
            let project = projectService.remove(project: project)
            state.projects = fetchProjects()
            let index = state.projects.firstIndex(of: project)
            if let index = index {
                let precedingProjectName: String
                if index > 0 {
                    precedingProjectName = state.projects[index - 1].name
                } else {
                    precedingProjectName = ""
                }
                trigger(.setCurrentProject(precedingProjectName))
            }
        }
    }
}
