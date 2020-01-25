//
//  HomeView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/21/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState = Routing.init()
    @State private var projectsStatus: Loadable<[Project]> = .notRequested
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.homeView)
    }
    
    private let cancelBag = CancelBag()
    
    var body: some View {
        NavigationView {
            self.content
                .navigationBarTitle("Projects")
                .navigationBarItems(trailing: AddView(show: routingBinding.addProjectSheet))
        }
        .onReceive(projectsUpdate) { self.projectsStatus = $0 }
        .onReceive(routingUpdate) { self.routingState = $0 }
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
private extension HomeView {
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
private extension HomeView {
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
private extension HomeView {
    func loadedView(_ projects: [Project]) -> some View {
        List(projects) { project in
            NavigationLink(destination: self.detailsView(project: project),
                           tag: project.name,
                           selection: self.routingBinding.selectedProject) {
                            Text("\(project.name)")
            }
        }
        .sheet(isPresented: routingBinding.addProjectSheet, content: { self.modalAddProjectView() })
    }
    
    func detailsView(project: Project) -> some View {
        ProjectDetailsView(project: project)
    }
    
    func modalAddProjectView() -> some View {
        AddProjectView(show: routingBinding.addProjectSheet, existingProject: nil, onCommit: addProject)
    }
}

// MARK: - Routing
extension HomeView {
    struct Routing: Equatable {
        @UserDefault("selected_project", defaultValue: nil)
        var selectedProject: String?
        
        var addProjectSheet: Bool = false
    }
}

// MARK: - State Updates
private extension HomeView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.homeView)
    }
    
    var projectsUpdate: AnyPublisher<Loadable<[Project]>, Never> {
        injected.appState.updates(for: \.userData.projects)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let view = HomeView().inject(.preview)
        return view
    }
}
#endif
