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

protocol ProjectsInteractor {
    func loadProjects() -> AnyCancellable
    func load(projectDetails: Binding<Loadable<ProjectDetails>>, project: Project) -> AnyCancellable
}

struct RealProjectsInteractor: ProjectsInteractor {
    let projectsRepository: ProjectsLocalRepository
    let appState: Store<AppState>
    
    func loadProjects() -> AnyCancellable {
        let projects = appState.value.userData.projects.value
        appState[\.userData.projects] = .isLoading(last: projects)
        weak var weakAppState = appState
        return projectsRepository.loadProjects()
            .sinkToLoadable { weakAppState?[\.userData.projects] = $0 }
    }
    
    func load(projectDetails: Binding<Loadable<ProjectDetails>>, project: Project) -> AnyCancellable {
        var tasks = project.allTasks
        var currentTask: Task? = nil
        if let latestTask = tasks.first {
            currentTask = latestTask
            tasks.removeFirst()
        }
        
        return Just(ProjectDetails(currentTask: currentTask, completedTasks: tasks))
            .sinkToLoadable { projectDetails.wrappedValue = $0 }
    }
}

struct StubProjectsInteractor: ProjectsInteractor {
    func loadProjects() -> AnyCancellable {
        return .cancelled
    }
    
    func load(projectDetails: Binding<Loadable<ProjectDetails>>, project: Project)  -> AnyCancellable {
        return .cancelled
    }
}
