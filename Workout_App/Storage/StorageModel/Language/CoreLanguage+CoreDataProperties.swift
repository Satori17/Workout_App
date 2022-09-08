//
//  CoreLanguage+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//
//

import Foundation
import CoreData


extension CoreLanguage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreLanguage> {
        return NSFetchRequest<CoreLanguage>(entityName: "CoreLanguage")
    }

    @NSManaged public var id: Int64
    @NSManaged public var shortName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var workout: CoreWorkout?

}

extension CoreLanguage : Identifiable {

}
