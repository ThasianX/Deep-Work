//
//  ProjectDetails.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import Combine

struct ProjectDetailsView: View {
    @Environment(\.injected) private var injected: DIContainer
    @State private var projectDetails: Loadable<ProjectDetails>
    
    @Binding var name: String
    private let cancelBag = CancelBag()
    
    init(name: Binding<String>, projectDetails: Loadable<ProjectDetails> = .notRequested) {
        self._name = name
        self._projectDetails = .init(initialValue: projectDetails)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
            Spacer()
        }
    }
    
    private var content: AnyView {
        switch projectDetails {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last): return AnyView(loadingView(last))
        case let .loaded(details): return AnyView(loadedView(details))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}

// MARK: - Side Effects
private extension ProjectDetailsView {
    func loadProjectDetails() {
        injected.interactors.projectsInteractor
            .load(name: name, projectDetails: $projectDetails)
            .store(in: cancelBag)
    }
}

// MARK: - Loading Content
private extension ProjectDetailsView {
    var notRequestedView: some View {
        Text("").onAppear {
            self.loadProjectDetails()
        }
    }
    
    func loadingView(_ previouslyLoaded: ProjectDetails?) -> some View {
        VStack {
            ActivityIndicator().padding()
            previouslyLoaded.map {
                loadedView($0)
            }
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.loadProjectDetails()
        })
    }
}

// MARK: - Displaying Content
private extension ProjectDetailsView {
    func loadedView(_ projectDetails: ProjectDetails) -> some View {
        List(projectDetails.completedTasks) { task in
            Text("\(task.name)")
        }
    }
}

// MARK: - State Updates
private extension ProjectDetailsView {
    var routingUpdate: AnyPublisher<ProjectMasterView.Routing, Never> {
        injected.appState.updates(for: \.routing.masterView)
    }
}

struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsView(name: .constant(Project.previewProjects().first!.name), projectDetails: .loaded(.mock)).inject(.preview)
    }
}
