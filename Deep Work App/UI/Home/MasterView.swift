//
//  MasterView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    @EnvironmentObject private var viewModel: AnyViewModel<HomeState, HomeInput>
    @State private var addProjectSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            masterHeader
            content
            Spacer()
        }
    }
}

// MARK: - Side Effects
private extension MasterView {
    func addProject(name: String) {
        viewModel.trigger(.addProject(name))
    }
    
    func select(project: Project) {
        viewModel.trigger(.setCurrentProject(project.name))
    }
}

// MARK: - Displaying Content
private extension MasterView {
    private var masterHeader: some View {
        HStack {
            Text("Projects")
                .font(.headline)
            Spacer()
            AddView(show: $addProjectSheet)
        }
        .padding()
        .background(Color.secondary.colorInvert())
    }
    
    private var content: some View {
        List(viewModel.projects) { project in
            ProjectListRow(
                project: project,
                selected: project.name == self.viewModel.currentProjectName,
                onClick: self.select)
        }
        .sheet(isPresented: $addProjectSheet, content: { self.modalAddProjectView() })
    }
    
    func modalAddProjectView() -> some View {
        AddProjectView(show: $addProjectSheet, existingProject: nil, onCommit: addProject)
    }
}

private extension MasterView {
    struct ProjectListRow: View {
        let project: Project
        let selected: Bool
        let onClick: (Project) -> Void
        
        var body: some View {
            Button(action: {
                self.onClick(self.project)
            }) {
                Text(project.name)
                    .background(selected ? Color.blue : nil)
            }
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}

//struct MasterState {
//    var projects: [AnyViewModel<DetailState, DetailInput>]
//}
//
//extension DetailState: Identifiable {
//    var id: Project.ID {
//        project.id
//    }
//}
//
//enum MasterInput {
//    case addProject(String)
//}
//
//class MasterViewModel: ViewModel {
//    @Published var state: MasterState
//
//    private let projectService: ProjectService
//
//    init(projectService: ProjectService) {
//        self.projectService = projectService
//
//        self.state = MasterState(
//            projects: projectService.loadProjects().map {
//                AnyViewModel(DetailViewModel(project: $0, projectService: projectService))
//            }
//        )
//    }
//
//    func trigger(_ input: MasterInput) {
//        switch input {
//        case let .addProject(name):
//            let project = Project.createProject(name: name)
//            let viewModel = AnyViewModel(DetailViewModel(project: project, projectService: projectService))
//            state.projects.append(viewModel)
//        }
//    }
//}
