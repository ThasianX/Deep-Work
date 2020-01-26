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
    @EnvironmentObject
    private var viewModel: AnyViewModel<HomeState, HomeInput>
    
    
    
    private let cancelBag = CancelBag()
    
    var body: some View {
        VStack {
            self.header
            NavigationView {
                self.content.navigationBarTitle("Projects", displayMode: .inline)
                    .navigationBarItems(
                        trailing: AddView(show: routingBinding.addProjectSheet)
                )
            }
            .onReceive(projectsUpdate) { self.projectsStatus = $0 }
            .onReceive(routingUpdate) { self.routingState = $0 }
        }
    }
    
    private var header: some View {
        HStack {
            Image(systemName: "gear").imageScale(.large)
            Spacer()
            Image(systemName: "gear").imageScale(.large)
        }
        .padding()
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
        var selectedProject: String? = AppUserDefaults.selectedProject
        
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
