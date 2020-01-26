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
    
    var fullScreen: Bool
    var projects: [Project]
    
    var currentProject: Project
    var projectDetails: ProjectDetails
}

enum HomeInput {
    case toggleFullScreen
    case setCurrentProject(Project)
    case addProject(String)
    case deleteProject(Project)
}

class HomeViewModel: ViewModel {
    @Published var state: HomeState
    
    private let projectService: ProjectService
    
    init(projectService: ProjectService) {
        self.projectService = projectService
        self.state = HomeState(
            fullScreen: false,
            projects: projectService.loadProjects(),
            currentProject: .stub,
            projectDetails: .stub)
        self.state.currentProject = projectService.load(name: state.currentProjectName)
        self.state.projectDetails = projectService.projectDetails(for: state.currentProject)
    }
    
    func fetchProjects() -> [Project] {
        projectService.loadProjects()
    }
    
    func trigger(_ input: HomeInput) {
        switch input {
        case .toggleFullScreen:
            state.fullScreen.toggle()
        case let .setCurrentProject(project):
            state.currentProjectName = project.name
        case let .addProject(name):
            let project = projectService.addProject(name: name)
            state.projects = fetchProjects()
            trigger(.setCurrentProject(project))
        case let .deleteProject(project):
            let project = projectService.remove(project: project)
            state.projects = fetchProjects()
            let index = state.projects.firstIndex(of: project)
            if let index = index {
                let precedingProject: Project
                if index > 0 {
                    precedingProject = state.projects[index - 1]
                } else {
                    precedingProject = .stub
                }
                trigger(.setCurrentProject(precedingProject))
            }
        }
    }
}
