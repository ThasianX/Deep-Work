//
//  AppUserDefaults.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/25/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import Foundation

struct AppUserDefaults {
    @UserDefault("selected_project", defaultValue: Project.stub)
    static var selectedProject: Project
}
