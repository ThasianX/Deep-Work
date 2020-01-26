//
//  DetailView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject private var viewModel: AnyViewModel<DetailState, DetailInput>
    
    var body: some View {
        content
    }
    
    var content: some View {
        completedTasks
    }
}

// MARK: - Side Effects
private extension DetailView {
    
}

// MARK: - Displaying Content
private extension DetailView {
    var completedTasks: some View {
        List(viewModel.projectDetails.completedTasks) { task in
            Text("\(task.name)")
        }
    }
}

struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

struct DetailState {
    var project: Project
    var projectDetails: ProjectDetails
}

enum DetailInput {
    //    case addTask(Task)
}

class DetailViewModel: ViewModel {
    @Published var state: DetailState
    
    private let projectService: ProjectService
    private let project: Project
    
    init(project: Project, projectService: ProjectService) {
        func projectDetails(project: Project) -> ProjectDetails {
            var tasks = project.allTasks
            var currentTask: Task? = nil
            if let latestTask = tasks.first {
                currentTask = latestTask
                tasks.removeFirst()
            }
            
            return ProjectDetails(currentTask: currentTask, completedTasks: tasks)
        }
        
        self.projectService = projectService
        self.project = project
        self.state = DetailState(project: project, projectDetails: projectDetails(project: project))
    }
    
    func trigger(_ input: DetailInput) {
        
    }
}
