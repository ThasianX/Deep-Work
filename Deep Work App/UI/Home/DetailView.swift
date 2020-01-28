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
    @State private var taskName: String = ""
    @State private var taskDuration: String = ""
    @State private var taskMeasureOfSuccess: String = ""
    @Binding var taskViewShown: Bool
    
    var body: some View {
        content
    }
    
    var content: some View {
        GeometryReader { geometry in
            VStack {
                self.deepWorkChart(width: geometry.size.width * 0.95, height: geometry.size.height * 0.9 / 2)
                HStack {
                    self.completedTasks(completedTasks: self.viewModel.projectDetails?.completedTasks ?? [])
                        .frame(width: geometry.size.width * 2 / 3)
                    Spacer()
                    self.taskView(currentTask: self.viewModel.projectDetails?.currentTask, length: geometry.size.width / 4)
                    Spacer()
                }
            }
        }
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
    
    func taskView(currentTask: Task?, length: CGFloat) -> some View {
        ZStack {
            if currentTask != nil {
                Text("")
            } else {
                SelectionDial(start: $taskViewShown, initialValue: 30, length: length)
            }
        }
    }
    
    func deepWorkChart(width: CGFloat, height: CGFloat) -> some View {
        BarChartView(data: ChartData(values: [("Jan 8, 2020", 500), ("Jan 9, 2020", 700), ("Jan 10, 2020", 800), ("Jan 11, 2020", 400), ("Jan 12, 2020", 1000), ("Jan 13, 2020", 300), ("Jan 14, 2020", 400), ("Jan 15, 2020", 900)]), title: "Deep Work Hours", legend: "Daily", form: CGSize(width: width, height: height), cornerImage: Image(systemName: "clock.fill"))
    }
}

//struct LabelField: View {
//    let label: String
//
//}

struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AnyViewModel(HomeViewModel(projectService: LocalProjectService()))
        return DetailView(taskViewShown: .constant(false))
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
