//
//  DeepWork+CoreDataClass.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/26/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DeepWork)
public class DeepWork: NSManagedObject {
    class func allInOrder() -> [DeepWork] {
        let datasource = CoreDataDataSource<DeepWork>()
        return datasource.fetch()
    }
    
//    #if DEBUG
//    class func previewSessions() -> [DeepWork] {
//        var projects = [Project]()
//        let project1 = createProject(name: "School")
//        for _ in 0...3 {
//            Task.createTask(name: "Write english essay", duration: 60, measureOfSuccess: "At least 1 page written", project: project1)
//        }
//        projects.append(project1)
//
//        let project2 = createProject(name: "Personal")
//        for _ in 0...3 {
//            Task.createTask(name: "Work on personal website", duration: 60, measureOfSuccess: "At least 1 screen finished", project: project2)
//        }
//        projects.append(project2)
//
//        let project3 = createProject(name: "Fitness")
//        for _ in 0...3 {
//            Task.createTask(name: "Go to the gym", duration: 60, measureOfSuccess: "45 minutes in the gym", project: project3)
//        }
//        projects.append(project3)
//
//        return projects
//    }
//    #endif
    
    // MARK: CRUD
    private class func newSession() -> DeepWork {
        DeepWork(context: CoreData.stack.context)
    }
    
    @discardableResult
    class func createSession(time: Double, project: Project) -> DeepWork {
        let session = DeepWork.newSession()
        
        session.time = time
        session.project = project
        CoreData.stack.save()
        
        return session
    }
    
    public func add(time: Double) {
        self.time += time
        CoreData.stack.save()
    }
    
    public func delete() {
        CoreData.stack.context.delete(self)
    }
}
