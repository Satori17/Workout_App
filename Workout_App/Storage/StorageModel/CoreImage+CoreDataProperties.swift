//
//  CoreImage+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//
//

import Foundation
import CoreData


extension CoreImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreImage> {
        return NSFetchRequest<CoreImage>(entityName: "CoreImage")
    }

    @NSManaged public var image: String?
    @NSManaged public var isMain: Bool
    @NSManaged public var id: Int64
    @NSManaged public var workout: CoreWorkout?

}

extension CoreImage : Identifiable {

}
