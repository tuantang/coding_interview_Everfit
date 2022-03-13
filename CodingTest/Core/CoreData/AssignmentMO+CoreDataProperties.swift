//
//  AssignmentMO+CoreDataProperties.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//
//

import Foundation
import CoreData


@available(iOS 13.0, *)
extension AssignmentMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssignmentMO> {
        return NSFetchRequest<AssignmentMO>(entityName: "Assignment")
    }

    @NSManaged public var id: String?
    @NSManaged public var status: Int16
    @NSManaged public var title: String?
    @NSManaged public var totalExercise: Int16
    @NSManaged public var workout: WorkoutMO?
    
    static func insertNewAssignment(id: String, title: String, status: Int16, totalExercise: Int16) -> AssignmentMO? {
        let assignment = NSEntityDescription.insertNewObject(forEntityName: "Assignment", into: AppDelegate.managedObjectContext!) as! AssignmentMO
        assignment.id = id
        assignment.title = title
        assignment.status = status
        assignment.totalExercise = totalExercise
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let error = error as NSError
            print(error.localizedDescription)
            return nil
        }
        print("Assignment Insert success")
        return assignment
    }
    
    

}
