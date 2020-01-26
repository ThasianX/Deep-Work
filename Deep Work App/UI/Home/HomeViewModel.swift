//
//  HomeViewModel.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct HomeState {
    @UserDefault(Constants.UserDefaults.selectedProject, defaultValue: "")
    var selectedProject: String
    
    var fullScreen: Bool
}

enum HomeInput {
    case toggleFullScreen
    case setSelectedProject(String)
}

class HomeViewModel: ViewModel {
    @Published
    var state: HomeState
    
    init() {
        self.state = HomeState(fullScreen: false)
    }
    
    func trigger(_ input: HomeInput) {
        switch input {
        case .toggleFullScreen:
            state.fullScreen.toggle()
        case let .setSelectedProject(project):
            state.selectedProject = project
        }
    }
}
