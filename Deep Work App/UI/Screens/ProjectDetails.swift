//
//  ProjectDetails.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct ProjectDetails: View {
    @Environment(\.injected) private var injected: DIContainer
    let project: Project
    private let cancelBag = CancelBag()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProjectDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetails(project: Project.previewProjects().first!)
    }
}
