//
//  ProjectsLocalRepository.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/23/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation
import Combine

struct ProjectsLocalRepository: ProjectLoader {
    func loadProjects() -> AnyPublisher<[Project], Never> {
        return Just(Project.allInOrder()).eraseToAnyPublisher()
    }
}
