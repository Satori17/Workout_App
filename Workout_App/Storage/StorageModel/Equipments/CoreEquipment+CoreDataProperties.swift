//
//  CoreEquipment+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//
//

import Foundation
import CoreData


extension CoreEquipment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreEquipment> {
        return NSFetchRequest<CoreEquipment>(entityName: "CoreEquipment")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var workout: CoreWorkout?

}

extension CoreEquipment : Identifiable {

}
