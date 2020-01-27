//
//  DetailView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct DetailView: View {
    @EnvironmentObject private var viewModel: AnyViewModel<HomeState, HomeInput>
    
    var body: some View {
        content
    }
    
    var content: some View {
        completedTasks(completedTasks: viewModel.projectDetails?.completedTasks ?? [])
    }
}

// MARK: - Side Effects
private extension DetailView {
    
}

// MARK: - Displaying Content
private extension DetailView {
    func completedTasks(completedTasks: [Task]) -> some View {
        List(completedTasks) { task in
            Text("\(task.name)")
        }
    }
}

struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AnyViewModel(HomeViewModel(projectService: LocalProjectService()))
        return DetailView()
            .environmentObject(viewModel)
    }
}

//struct DetailState {
//    var project: Project
//    var projectDetails: ProjectDetails
//}
//
//enum DetailInput {
//    //    case addTask(Task)
//}
//
//class DetailViewModel: ViewModel {
//    @Published var state: DetailState
//
//    private let projectService: ProjectService
//    private let project: Project
//
//    init(project: Project, projectService: ProjectService) {
//        self.projectService = projectService
//        self.project = project
//        self.state = DetailState(project: project, projectDetails: projectService.projectDetails(for: project))
//    }
//
//    func trigger(_ input: DetailInput) {
//
//    }
//}
