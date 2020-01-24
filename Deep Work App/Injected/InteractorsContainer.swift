//
//  InteractorsContainer.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/21/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

extension DIContainer {
    struct Interactors {
        let projectsInteractor: ProjectsInteractor
        
        static var stub: Self {
            .init(projectsInteractor: StubProjectsInteractor())
        }
    }
}
