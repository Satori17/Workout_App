//
//  CoreMuscle+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//
//

import Foundation
import CoreData


extension CoreMuscle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreMuscle> {
        return NSFetchRequest<CoreMuscle>(entityName: "CoreMuscle")
    }

    @NSManaged public var imageUrlMain: String?
    @NSManaged public var imageUrlSecondary: String?
    @NSManaged public var isFront: Bool
    @NSManaged public var name: String?
    @NSManaged public var workout: CoreWorkout?
    @NSManaged public var workout2: CoreWorkout?

}

extension CoreMuscle : Identifiable {

}
