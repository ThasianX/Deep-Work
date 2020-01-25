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
        return "\(existingProject != nil ? "Edit" : "Add") Project"
    }
    
    var commit: String {
        return "\(existingProject != nil ? "Save" : "Add")"
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            
            Text("Project Name")
            TextField("", text: $input)
            
            HStack {
                Spacer()
                Button(action: { self.show = false} ) {
                    Text("Cancel")
                }
                Button(action: {
                    self.show = false
                    self.onCommit(self.input)
                }) {
                    Text(commit)
                }
                .disabled(input.isEmpty)
            }
        }
        .padding()
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView(show: .constant(true), existingProject: nil, onCommit: { _ in })
    }
}
