//
//  CoreComment+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//
//

import Foundation
import CoreData


extension CoreComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreComment> {
        return NSFetchRequest<CoreComment>(entityName: "CoreComment")
    }

    @NSManaged public var id: Int64
    @NSManaged public var exercise: Int64
    @NSManaged public var comment: String?
    @NSManaged public var workout: CoreWorkout?

}

extension CoreComment : Identifiable {

}
