//
//  HomeViewModel.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct HomeState {
    @UserDefault(Constants.UserDefaults.selectedProject, defaultValue: .stub)
    var currentProject: Project
    
    var fullScreen: Bool
    
    var master: AnyViewModel<MasterState, MasterInput>
    var detail: AnyViewModel<DetailState, DetailInput>
}

enum HomeInput {
    case toggleFullScreen
    case setCurrentProject(Project)
}

class HomeViewModel: ViewModel {
    @Published var state: HomeState
    
    init(projectService: ProjectService) {
        self.state = HomeState(
            fullScreen: false,
            master: AnyViewModel(MasterViewModel(projectService: projectService)),
            detail: AnyViewModel(DetailViewModel(project: .stub, projectService: projectService))
        )
    }
    
    func trigger(_ input: HomeInput) {
        switch input {
        case .toggleFullScreen:
            state.fullScreen.toggle()
        case let .setCurrentProject(project):
            print("\(project)")
            state.currentProject = project
        }
    }
}
