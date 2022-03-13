//
//  WorkoutMO+CoreDataProperties.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutMO> {
        return NSFetchRequest<WorkoutMO>(entityName: "Workout")
    }

    @NSManaged public var day: Int16
    @NSManaged public var id: String?
    @NSManaged public var assignments: NSSet?

}

// MARK: Generated accessors for assignments
@available(iOS 13.0, *)
extension WorkoutMO {

    @objc(addAssignmentsObject:)
    @NSManaged public func addToAssignments(_ value: AssignmentMO)

    @objc(removeAssignmentsObject:)
    @NSManaged public func removeFromAssignments(_ value: AssignmentMO)

    @objc(addAssignments:)
    @NSManaged public func addToAssignments(_ values: NSSet)

    @objc(removeAssignments:)
    @NSManaged public func removeFromAssignments(_ values: NSSet)
    
    static func insertNewWorkOut(id: String, day: Int16) -> WorkoutMO? {
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: AppDelegate.managedObjectContext!) as! WorkoutMO
        workout.id = id
        workout.day = day
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let error = error as NSError
            print(error.localizedDescription)
            return nil
        }
        print("Workout Insert success")
        return workout
    }
    
    static func getAll() -> [WorkoutMO] {
        var results = [WorkoutMO]()
        let moc = AppDelegate.managedObjectContext
        do {
            results = try moc!.fetch(WorkoutMO.fetchRequest()) as! [WorkoutMO]
        } catch {
            let error = error as NSError
            print(error.localizedDescription)
            return results
        }
        return results
    }
    
    static func deleteAll() -> Bool {
        let moc = AppDelegate.managedObjectContext
        let workouts = WorkoutMO.getAll()
        workouts.forEach { moc?.delete($0) }
        do {
            try AppDelegate.managedObjectContext?.save()
        } catch {
            let error = error as NSError
            print(error.localizedDescription)
            return false
        }
        return true
    }

}
