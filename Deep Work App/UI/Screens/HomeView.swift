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
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.homeView)
    }
    
    private let cancelBag = CancelBag()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.header(masterWidth: geometry.size.width / 3.5, detailWidth:  geometry.size.width - (geometry.size.width / 3.5))
                    .frame(maxHeight: 60)
                HStack {
                    if !self.routingState.fullScreen {
                        ProjectMasterView()
                            .frame(width: geometry.size.width / 3.5)
                    }
                    
                    Rectangle()
                        .background(Color.black)
                        .frame(width: self.routingState.fullScreen ? geometry.size.width : geometry.size.width - (geometry.size.width / 3.5))
                }
            }
        }
    }
    
    func header(masterWidth: CGFloat, detailWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            HStack {
                if !routingState.fullScreen {
                    HStack {
                        Image(systemName: "gear").imageScale(.large)
                        Spacer()
                        Image(systemName: "gear").imageScale(.large)
                    }
                    .padding()
                    .frame(width: masterWidth)
                    
                    Divider()
                }
                
                HStack {
                    Button(action: {
                        withAnimation {
                            self.routingState.fullScreen.toggle()
                        }
                    }) {
                        Image(systemName: routingState.fullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right").imageScale(.large)
                    }
                    Text(injected.appState.value.routing.masterView.selectedProject)
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Image(systemName: "pencil.circle").imageScale(.large)
                }
                .padding()
                .frame(width: routingState.fullScreen ? masterWidth + detailWidth : detailWidth)
            }
            Divider()
        }
    }
}

// MARK: - Side Effects
private extension HomeView {
    
}

// MARK: - Loading Content
private extension HomeView {
}

// MARK: - Displaying content
private extension HomeView {
    func detailsView(project: Project) -> some View {
        ProjectDetailsView(project: project)
    }
}

// MARK: - Routing
extension HomeView {
    struct Routing: Equatable {
        var fullScreen: Bool = false
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
