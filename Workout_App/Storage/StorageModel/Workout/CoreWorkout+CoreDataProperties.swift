//
//  CoreWorkout+CoreDataProperties.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.09.22.
//
//

import Foundation
import CoreData


extension CoreWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreWorkout> {
        return NSFetchRequest<CoreWorkout>(entityName: "CoreWorkout")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var reps: Int64
    @NSManaged public var sets: Int64
    @NSManaged public var weekDay: String?
    @NSManaged public var category: CoreCategory?
    @NSManaged public var comments: NSOrderedSet?
    @NSManaged public var equipments: NSOrderedSet?
    @NSManaged public var images: NSOrderedSet?
    @NSManaged public var language: CoreLanguage?
    @NSManaged public var muscles: NSOrderedSet?
    @NSManaged public var musclesSecondary: NSOrderedSet?

}

// MARK: Generated accessors for comments
extension CoreWorkout {

    @objc(insertObject:inCommentsAtIndex:)
    @NSManaged public func insertIntoComments(_ value: CoreComment, at idx: Int)

    @objc(removeObjectFromCommentsAtIndex:)
    @NSManaged public func removeFromComments(at idx: Int)

    @objc(insertComments:atIndexes:)
    @NSManaged public func insertIntoComments(_ values: [CoreComment], at indexes: NSIndexSet)

    @objc(removeCommentsAtIndexes:)
    @NSManaged public func removeFromComments(at indexes: NSIndexSet)

    @objc(replaceObjectInCommentsAtIndex:withObject:)
    @NSManaged public func replaceComments(at idx: Int, with value: CoreComment)

    @objc(replaceCommentsAtIndexes:withComments:)
    @NSManaged public func replaceComments(at indexes: NSIndexSet, with values: [CoreComment])

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CoreComment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CoreComment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSOrderedSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSOrderedSet)

}

// MARK: Generated accessors for equipments
extension CoreWorkout {

    @objc(insertObject:inEquipmentsAtIndex:)
    @NSManaged public func insertIntoEquipments(_ value: CoreEquipment, at idx: Int)

    @objc(removeObjectFromEquipmentsAtIndex:)
    @NSManaged public func removeFromEquipments(at idx: Int)

    @objc(insertEquipments:atIndexes:)
    @NSManaged public func insertIntoEquipments(_ values: [CoreEquipment], at indexes: NSIndexSet)

    @objc(removeEquipmentsAtIndexes:)
    @NSManaged public func removeFromEquipments(at indexes: NSIndexSet)

    @objc(replaceObjectInEquipmentsAtIndex:withObject:)
    @NSManaged public func replaceEquipments(at idx: Int, with value: CoreEquipment)

    @objc(replaceEquipmentsAtIndexes:withEquipments:)
    @NSManaged public func replaceEquipments(at indexes: NSIndexSet, with values: [CoreEquipment])

    @objc(addEquipmentsObject:)
    @NSManaged public func addToEquipments(_ value: CoreEquipment)

    @objc(removeEquipmentsObject:)
    @NSManaged public func removeFromEquipments(_ value: CoreEquipment)

    @objc(addEquipments:)
    @NSManaged public func addToEquipments(_ values: NSOrderedSet)

    @objc(removeEquipments:)
    @NSManaged public func removeFromEquipments(_ values: NSOrderedSet)

}

// MARK: Generated accessors for images
extension CoreWorkout {

    @objc(insertObject:inImagesAtIndex:)
    @NSManaged public func insertIntoImages(_ value: CoreImage, at idx: Int)

    @objc(removeObjectFromImagesAtIndex:)
    @NSManaged public func removeFromImages(at idx: Int)

    @objc(insertImages:atIndexes:)
    @NSManaged public func insertIntoImages(_ values: [CoreImage], at indexes: NSIndexSet)

    @objc(removeImagesAtIndexes:)
    @NSManaged public func removeFromImages(at indexes: NSIndexSet)

    @objc(replaceObjectInImagesAtIndex:withObject:)
    @NSManaged public func replaceImages(at idx: Int, with value: CoreImage)

    @objc(replaceImagesAtIndexes:withImages:)
    @NSManaged public func replaceImages(at indexes: NSIndexSet, with values: [CoreImage])

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: CoreImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: CoreImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSOrderedSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSOrderedSet)

}

// MARK: Generated accessors for muscles
extension CoreWorkout {

    @objc(insertObject:inMusclesAtIndex:)
    @NSManaged public func insertIntoMuscles(_ value: CoreMuscle, at idx: Int)

    @objc(removeObjectFromMusclesAtIndex:)
    @NSManaged public func removeFromMuscles(at idx: Int)

    @objc(insertMuscles:atIndexes:)
    @NSManaged public func insertIntoMuscles(_ values: [CoreMuscle], at indexes: NSIndexSet)

    @objc(removeMusclesAtIndexes:)
    @NSManaged public func removeFromMuscles(at indexes: NSIndexSet)

    @objc(replaceObjectInMusclesAtIndex:withObject:)
    @NSManaged public func replaceMuscles(at idx: Int, with value: CoreMuscle)

    @objc(replaceMusclesAtIndexes:withMuscles:)
    @NSManaged public func replaceMuscles(at indexes: NSIndexSet, with values: [CoreMuscle])

    @objc(addMusclesObject:)
    @NSManaged public func addToMuscles(_ value: CoreMuscle)

    @objc(removeMusclesObject:)
    @NSManaged public func removeFromMuscles(_ value: CoreMuscle)

    @objc(addMuscles:)
    @NSManaged public func addToMuscles(_ values: NSOrderedSet)

    @objc(removeMuscles:)
    @NSManaged public func removeFromMuscles(_ values: NSOrderedSet)

}

// MARK: Generated accessors for musclesSecondary
extension CoreWorkout {

    @objc(insertObject:inMusclesSecondaryAtIndex:)
    @NSManaged public func insertIntoMusclesSecondary(_ value: CoreMuscle, at idx: Int)

    @objc(removeObjectFromMusclesSecondaryAtIndex:)
    @NSManaged public func removeFromMusclesSecondary(at idx: Int)

    @objc(insertMusclesSecondary:atIndexes:)
    @NSManaged public func insertIntoMusclesSecondary(_ values: [CoreMuscle], at indexes: NSIndexSet)

    @objc(removeMusclesSecondaryAtIndexes:)
    @NSManaged public func removeFromMusclesSecondary(at indexes: NSIndexSet)

    @objc(replaceObjectInMusclesSecondaryAtIndex:withObject:)
    @NSManaged public func replaceMusclesSecondary(at idx: Int, with value: CoreMuscle)

    @objc(replaceMusclesSecondaryAtIndexes:withMusclesSecondary:)
    @NSManaged public func replaceMusclesSecondary(at indexes: NSIndexSet, with values: [CoreMuscle])

    @objc(addMusclesSecondaryObject:)
    @NSManaged public func addToMusclesSecondary(_ value: CoreMuscle)

    @objc(removeMusclesSecondaryObject:)
    @NSManaged public func removeFromMusclesSecondary(_ value: CoreMuscle)

    @objc(addMusclesSecondary:)
    @NSManaged public func addToMusclesSecondary(_ values: NSOrderedSet)

    @objc(removeMusclesSecondary:)
    @NSManaged public func removeFromMusclesSecondary(_ values: NSOrderedSet)

}

extension CoreWorkout : Identifiable {

}
