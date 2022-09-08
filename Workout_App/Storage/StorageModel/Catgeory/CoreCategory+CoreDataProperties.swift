//
//  CoreCategory+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//
//

import Foundation
import CoreData


extension CoreCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreCategory> {
        return NSFetchRequest<CoreCategory>(entityName: "CoreCategory")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var workout: CoreWorkout?

}

extension CoreCategory : Identifiable {

}
