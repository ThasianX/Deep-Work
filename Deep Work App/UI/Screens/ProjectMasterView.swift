//
//  ProjectMasterView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/25/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Combine

struct ProjectMasterView: View {
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState = Routing.init()
    @State private var projectsStatus: Loadable<[Project]> = .notRequested
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.masterView)
    }
    
    private let cancelBag = CancelBag()
    
    var body: some View {
        VStack(spacing: 0) {
            masterHeader
            content
            Spacer()
        }
        .onReceive(projectsUpdate) { self.projectsStatus = $0 }
        .onReceive(routingUpdate) { self.routingState = $0 }
    }
    
    private var masterHeader: some View {
        HStack {
            Text("Projects")
                .font(.headline)
            Spacer()
            AddView(show: routingBinding.addProjectSheet)
        }
        .padding()
        .background(Color.secondary.colorInvert())
    }
    
    private var content: AnyView {
        switch projectsStatus {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last): return AnyView(loadingView(last))
        case let .loaded(projects): return AnyView(loadedView(projects))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}


// MARK: - Side Effects
private extension ProjectMasterView {
    func loadProjects() {
        injected.interactors.projectsInteractor
            .loadProjects()
            .store(in: cancelBag)
    }
    
    func addProject(name: String) {
        injected.interactors.projectsInteractor
            .addProject(name: name)
            .store(in: cancelBag)
    }
}

// MARK: - Loading Content
private extension ProjectMasterView {
    var notRequestedView: some View {
        Text("").onAppear {
            self.loadProjects()
        }
    }
    
    func loadingView(_ previouslyLoaded: [Project]?) -> some View {
        VStack {
            ActivityIndicator().padding()
            previouslyLoaded.map {
                loadedView($0)
            }
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.loadProjects()
        })
    }
}

// MARK: - Displaying content
private extension ProjectMasterView {
    func loadedView(_ projects: [Project]) -> some View {
        List(projects) { project in
            Text("\(project.name)")
        }
        .sheet(isPresented: routingBinding.addProjectSheet, content: { self.modalAddProjectView() })
    }
    
    func modalAddProjectView() -> some View {
        AddProjectView(show: routingBinding.addProjectSheet, existingProject: nil, onCommit: addProject)
    }
}

// MARK: - Routing
extension ProjectMasterView {
    struct Routing: Equatable {
        var selectedProject: String = AppUserDefaults.selectedProject
        
        var addProjectSheet: Bool = false
    }
}

// MARK: - State Updates
private extension ProjectMasterView {
    var projectsUpdate: AnyPublisher<Loadable<[Project]>, Never> {
        injected.appState.updates(for: \.userData.projects)
    }
    
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.masterView)
    }
}

struct ProjectMasterView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectMasterView()
    }
}
