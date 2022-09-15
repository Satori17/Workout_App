//
//  CoreWeekDay+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 12.09.22.
//
//

import Foundation
import CoreData


extension CoreWeekDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreWeekDay> {
        return NSFetchRequest<CoreWeekDay>(entityName: "CoreWeekDay")
    }

    @NSManaged public var isScheduled: Bool
    @NSManaged public var name: String?
    @NSManaged public var scheduledTime: String?
    @NSManaged public var relationship: CoreWorkout?

}

extension CoreWeekDay : Identifiable {

}
