//
//  MasterView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    @EnvironmentObject private var viewModel: AnyViewModel<MasterState, MasterInput>
    
    @State private var addProjectSheet: Bool = false
    
    let currentProject: Project
    let onCommit: (Project) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            masterHeader
            content
            Spacer()
        }
    }
}

// MARK: - Side Effects
extension MasterView {
    func addProject(name: String) {
        viewModel.trigger(.addProject(name))
    }
}

// MARK: - Displaying Content
extension MasterView {
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
        List(viewModel.projects) { viewModel in
            Button(action: {
                self.onCommit(viewModel.project)
            }) {
                Text(viewModel.project.name)
                    .background(self.currentProject == viewModel.project ? Color.blue : nil)
            }
        }
        .sheet(isPresented: $addProjectSheet, content: { self.modalAddProjectView() })
    }
    
    func modalAddProjectView() -> some View {
        AddProjectView(show: $addProjectSheet, existingProject: nil, onCommit: addProject)
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(currentProject: .stub, onCommit: {_ in})
    }
}

struct MasterState {
    var projects: [AnyViewModel<DetailState, DetailInput>]
}

extension DetailState: Identifiable {
    var id: Project.ID {
        project.id
    }
}

enum MasterInput {
    case addProject(String)
}

class MasterViewModel: ViewModel {
    @Published
    var state: MasterState
    
    let projectService: ProjectService
    
    init(projectService: ProjectService) {
        self.projectService = projectService
        
        self.state = MasterState(
            projects: projectService.loadProjects().map {
                AnyViewModel(DetailViewModel(project: $0, projectService: projectService))
            }
        )
    }
    
    func trigger(_ input: MasterInput) {
        switch input {
        case let .addProject(name):
            let project = Project.createProject(name: name)
            let viewModel = AnyViewModel(DetailViewModel(project: project, projectService: projectService))
            state.projects.append(viewModel)
        }
    }
}
