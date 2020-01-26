//
//  ProjectDetails.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct ProjectDetailsView: View {
    @Environment(\.injected) private var injected: DIContainer
    @State private var projectDetails: Loadable<ProjectDetails>
    let project: Project
    private let cancelBag = CancelBag()
    
    init(project: Project, projectDetails: Loadable<ProjectDetails> = .notRequested) {
        self.project = project
        self._projectDetails = .init(initialValue: projectDetails)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
            Spacer()
        }
        .onAppear {
            self.setSelectedProject()
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
            .load(projectDetails: $projectDetails, project: project)
            .store(in: cancelBag)
    }
    
    func setSelectedProject() {
        injected.interactors.projectsInteractor
            .setSelectedProject(name: project.name)
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
        Text(project.name)
        //        List(projectDetails.completedTasks) { task in
        //            Text("\(task.name)")
        //        }
    }
}

struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsView(project: Project.previewProjects().first!, projectDetails: .loaded(.mock)).inject(.preview)
    }
}
