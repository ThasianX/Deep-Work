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
                        ProjectMasterView(selectedProject: self.routingBinding.selectedProject)
                            .frame(width: geometry.size.width / 3.5)
                    }
                    ProjectDetailsView(name: self.routingBinding.selectedProject)
                    .frame(width: self.routingState.fullScreen ? geometry.size.width : geometry.size.width - (geometry.size.width / 3.5))
                }
            }
            .onReceive(self.routingUpdate, perform: {
                print("\($0)")
                self.routingState = $0 })
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
                            self.toggleFullScreen()
                        }
                    }) {
                        Image(systemName: routingState.fullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right").imageScale(.large)
                    }
                    Text(self.routingBinding.selectedProject.wrappedValue)
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
    func toggleFullScreen() {
        injected.interactors.projectsInteractor
            .toggleFullScreen(fullScreen: routingBinding.fullScreen)
    }
}

// MARK: - Loading Content
private extension HomeView {
}

// MARK: - Displaying content
private extension HomeView {
}

// MARK: - Routing
extension HomeView {
    struct Routing: Equatable {
        var selectedProject: String = ""
        
        var fullScreen: Bool = false
    }
}

// MARK: - State Updates
private extension HomeView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.homeView)
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
