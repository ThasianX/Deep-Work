//
//  ProjectsInteractor.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum ProjectDetailsError: Error {
    case empty
}

protocol ProjectsInteractor {
    func loadProjects() -> AnyCancellable
    func load(name: String, projectDetails: Binding<Loadable<ProjectDetails>>) -> AnyCancellable
    func addProject(name: String, selectedProject: Binding<String>) -> AnyCancellable
    func setSelectedProject(project: Project, selectedProject: Binding<String>)
    func toggleFullScreen(fullScreen: Binding<Bool>)
}

struct RealProjectsInteractor: ProjectsInteractor {
    let projectsRepository: ProjectsLocalRepository
    let appState: Store<AppState>
    
    init(projectsRepository: ProjectsLocalRepository, appState: Store<AppState>) {
        self.projectsRepository = projectsRepository
        self.appState = appState
    }
    
    func loadProjects() -> AnyCancellable {
        let projects = appState.value.userData.projects.value
        appState[\.userData.projects] = .isLoading(last: projects)
        weak var weakAppState = appState
        return projectsRepository.loadProjects()
            .sinkToLoadable { weakAppState?[\.userData.projects] = $0 }
    }
    
    func load(name: String, projectDetails: Binding<Loadable<ProjectDetails>>) -> AnyCancellable {
        if let project = projectsRepository.getProject(name: name).first {
            var tasks = project.allTasks
            var currentTask: Task? = nil
            if let latestTask = tasks.first {
                currentTask = latestTask
                tasks.removeFirst()
            }
            
            return Just(ProjectDetails(currentTask: currentTask, completedTasks: tasks))
                .sinkToLoadable { projectDetails.wrappedValue = $0 }
        }
        return Just(ProjectDetails.empty)
            .sinkToLoadable { projectDetails.wrappedValue = $0 }
    }
    
    func addProject(name: String, selectedProject: Binding<String>) -> AnyCancellable {
        // set selected project to this new one
        let project = projectsRepository.addProject(name: name)
        setSelectedProject(project: project, selectedProject: selectedProject)
        return loadProjects()
    }
    
    func setSelectedProject(project: Project, selectedProject: Binding<String>) {
        selectedProject.wrappedValue = project.name
    }
    
    func toggleFullScreen(fullScreen: Binding<Bool>) {
        fullScreen.wrappedValue.toggle()
    }
}

struct StubProjectsInteractor: ProjectsInteractor {
    func loadProjects() -> AnyCancellable {
        return .cancelled
    }
    
    func load(name: String, projectDetails: Binding<Loadable<ProjectDetails>>) -> AnyCancellable {
        .cancelled
    }
    
    func addProject(name: String, selectedProject: Binding<String>) -> AnyCancellable {
        return .cancelled
    }
    
    func setSelectedProject(project: Project, selectedProject: Binding<String>) { }
    
    func toggleFullScreen(fullScreen: Binding<Bool>) { }
}
