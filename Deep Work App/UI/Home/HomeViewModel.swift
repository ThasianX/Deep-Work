//
//  HomeViewModel.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct HomeState {
    @UserDefault(Constants.UserDefaults.currentProject, defaultValue: "")
    var currentProject: String
    
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
        let currentProject = UserDefaults.standard.string(forKey: Constants.UserDefaults.currentProject) ?? ""
        
        func setCurrentProject(project: Project) {
            state.currentProject = project.name
        }
        
        self.state = HomeState(
            fullScreen: false,
            master: AnyViewModel(MasterViewModel(projectService: projectService)),
            detail: AnyViewModel(DetailViewModel(project: projectService.load(name: currentProject), projectService: projectService))
        )
    }
    
    func trigger(_ input: HomeInput) {
        switch input {
        case .toggleFullScreen:
            state.fullScreen.toggle()
        case let .setCurrentProject(project):
            state.currentProject = project.name
        }
    }
}
