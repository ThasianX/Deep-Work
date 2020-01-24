//
//  ProjectsInteractor.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation
import Combine

protocol ProjectsInteractor {
    func loadProjects() -> AnyCancellable
    
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
}

struct StubProjectsInteractor: ProjectsInteractor {
    func loadProjects() -> AnyCancellable {
        return .cancelled
    }
}
