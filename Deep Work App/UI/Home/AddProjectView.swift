//
//  AddProjectView.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/24/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct AddProjectView: View {
    @State private var input: String
    @Binding var show: Bool
    
    let existingProject: Project?
    let onCommit: (String) -> Void
    
    init(show: Binding<Bool>, existingProject: Project?, onCommit: @escaping (String) -> Void) {
        self._show = show
        self.existingProject = existingProject
        self._input = .init(initialValue: existingProject?.name ?? "")
        self.onCommit = onCommit
    }
    
    var title: String {
        return "\(existingProject != nil ? "Edit" : "New") Project"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name your project", text: $input)
                    .font(.headline)
                    .padding()
                Divider()
                Spacer()
            }
            .navigationBarTitle(Text(title).font(.headline), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var cancelButton: some View {
        Button(action: {
            self.show = false
        } ) {
            Text("Cancel")
        }
    }
    
    var doneButton: some View {
        Button(action: {
            self.show = false
            self.onCommit(self.input)
        }) {
            Text("Done")
        }
        .disabled(input.isEmpty)
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView(show: .constant(true), existingProject: nil, onCommit: { _ in})
    }
}
