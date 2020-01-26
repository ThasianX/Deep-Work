//
//  AppState.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/21/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
}

extension AppState {
    struct UserData: Equatable {
        var projects: Loadable<[Project]> = .notRequested
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var homeView = HomeView.Routing()
        var masterView = ProjectMasterView.Routing()
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
        lhs.routing == rhs.routing &&
        lhs.system == rhs.system
}

#if DEBUG
extension AppState {
    static var preview: Self {
        var state = AppState()
        state.userData.projects = .loaded(Project.previewProjects())
        state.system.isActive = true
        return state
    }
}
#endif
