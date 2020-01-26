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
    @EnvironmentObject private var viewModel: AnyViewModel<HomeState, HomeInput>
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.header(masterWidth: geometry.size.width / 3.5, detailWidth:  geometry.size.width - (geometry.size.width / 3.5))
                    .frame(maxHeight: 60)
                
                HStack(spacing: 0) {
                    if !self.viewModel.fullScreen {
                        MasterView(currentProject: self.viewModel.currentProject, onCommit: self.setCurrentProject)
                            .frame(width: geometry.size.width / 3.5)
                            .environmentObject(self.viewModel.master)
                    }
                    
                    DetailView()
                        .environmentObject(self.viewModel.detail)
                }
            }
        }
    }
}

// MARK: - Side Effects
private extension HomeView {
    func setCurrentProject(project: Project) {
        viewModel.trigger(.setCurrentProject(project))
    }
}

// MARK: - Displaying Content
private extension HomeView {
    func header(masterWidth: CGFloat, detailWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if !viewModel.state.fullScreen {
                    leadingMenu
                        .padding()
                        .frame(width: masterWidth)
                    
                    Divider()
                }
                
                trailingMenu
                    .padding()
            }
            Divider()
        }
    }
    
    var leadingMenu: some View {
        HStack {
            Image(systemName: "gear").imageScale(.large)
            Spacer()
            Image(systemName: "gear").imageScale(.large)
        }
    }
    
    var trailingMenu: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.viewModel.trigger(.toggleFullScreen)
                }
            }) {
                Image(systemName: viewModel.state.fullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right").imageScale(.large)
            }
            Text(viewModel.state.currentProject)
                .font(.system(size: 20))
                .bold()
            Spacer()
            Image(systemName: "pencil.circle").imageScale(.large)
        }
    }
}


#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let view = HomeView()
        return view
    }
}
#endif
