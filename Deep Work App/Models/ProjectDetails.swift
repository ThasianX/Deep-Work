//
//  ProjectDetails.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/24/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

struct ProjectDetails: Equatable {
    let currentTask: Task?
    let completedTasks: [Task]
}
