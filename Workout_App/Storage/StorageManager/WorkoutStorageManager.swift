//
//  WorkoutStorageManager.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit
import CoreData

protocol WorkoutStorageManagerLogic {
    func getAllWorkouts() throws -> [CoreWorkout]
    func addWorkout(fromModel model: Displayable, sets: Int, reps: Int, weekDay: String) throws -> CoreWorkout
    func removeWorkout(withId id: Int) throws
}

class WorkoutStorageManager {
    
    //MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var managedContext = appDelegate?.persistentContainer.viewContext
    
    //MARK: - configurator Methods
    
    private func categoryConfigurator(ofWorkout workout: CoreWorkout, withModel model: Displayable, managedContext: NSManagedObjectContext) {
        let categoryObject = CoreCategory(context: managedContext)
        categoryObject.id = Int64(model.category.id)
        categoryObject.name = model.category.name
        workout.category = categoryObject
    }
    
    private func musclesConfigurator(ofWorkout workout: CoreWorkout, withModel model: Displayable, managedContext: NSManagedObjectContext, isSecondary: Bool) {
        if !isSecondary {
            model.muscles.forEach {
                let musclesObject = CoreMuscle(context: managedContext)
                musclesObject.name = $0.name
                musclesObject.isFront = $0.isFront
                musclesObject.imageUrlMain = $0.imageUrlMain
                musclesObject.imageUrlSecondary = $0.imageUrlSecondary
                workout.addToMuscles(musclesObject)
            }
        } else {
            model.musclesSecondary.forEach {
                let musclesSecondaryObject = CoreMuscle(context: managedContext)
                musclesSecondaryObject.name = $0.name
                musclesSecondaryObject.isFront = $0.isFront
                musclesSecondaryObject.imageUrlMain = $0.imageUrlMain
                musclesSecondaryObject.imageUrlSecondary = $0.imageUrlSecondary
                workout.addToMusclesSecondary(musclesSecondaryObject)
            }
        }
    }
    
    private func equipmentConfigurator(ofWorkout workout: CoreWorkout, withModel model: Displayable, managedContext: NSManagedObjectContext) {
        model.equipment.forEach {
            let equipmentObject = CoreEquipment(context: managedContext)
            equipmentObject.id = Int64($0.id)
            equipmentObject.name = $0.name
            workout.addToEquipments(equipmentObject)
        }
    }
    
    private func languageConfigurator(ofWorkout workout: CoreWorkout, withModel model: Displayable, managedContext: NSManagedObjectContext) {
        let languageObject = CoreLanguage(context: managedContext)
        languageObject.id = Int64(model.language.id)
        languageObject.shortName = model.language.shortName
        languageObject.fullName = model.language.fullName
        workout.language = languageObject
    }
    
    private func imagesConfigurator(ofWorkout workout: CoreWorkout, withModel model: Displayable, managedContext: NSManagedObjectContext) {
        model.images.forEach {
            let imageObject = CoreImage(context: managedContext)
            imageObject.image = $0.image
            imageObject.isMain = $0.isMain
            workout.addToImages(imageObject)
        }
    }
    
    private func commentsConfigurator(ofWorkout workout: CoreWorkout, withModel model: Displayable, managedContext: NSManagedObjectContext) {
        model.comments.forEach {
            let commentObject = CoreComment(context: managedContext)
            commentObject.id = Int64($0.id)
            commentObject.exercise = Int64($0.exercise)
            commentObject.comment = $0.comment
            workout.addToComments(commentObject)
        }
    }
    
}


extension WorkoutStorageManager: WorkoutStorageManagerLogic {
    
    func getAllWorkouts() throws -> [CoreWorkout] {
        guard let managedContext = managedContext else { throw StorageManagerError.managedContextFailed }
        do {
            let result = try managedContext.fetch(CoreWorkout.fetchRequest())
            return result
        } catch {
            throw StorageManagerError.fetchFailed
        }
    }
    
    func addWorkout(fromModel model: Displayable, sets: Int, reps: Int, weekDay: String) throws -> CoreWorkout {
        guard let managedContext = managedContext else { throw StorageManagerError.managedContextFailed }
        let workoutToAdd = CoreWorkout(context: managedContext)
        workoutToAdd.id = Int64(model.id)
        workoutToAdd.name = model.name
        workoutToAdd.descriptionText = model.description
        workoutToAdd.sets = Int64(sets)
        workoutToAdd.reps = Int64(reps)
        workoutToAdd.weekDay = weekDay
        categoryConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext)
        musclesConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext, isSecondary: false)
        musclesConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext, isSecondary: true)
        equipmentConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext)
        languageConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext)
        imagesConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext)
        commentsConfigurator(ofWorkout: workoutToAdd, withModel: model, managedContext: managedContext)
        
        do {
            try managedContext.save()
        } catch {
            throw StorageManagerError.saveFailed
        }
        
        return workoutToAdd
    }
    
    func removeWorkout(withId id: Int) throws {
        guard let managedContext = managedContext else { throw StorageManagerError.managedContextFailed }
        let request = CoreWorkout.fetchRequest()
        
        request.predicate = NSPredicate(format: "id = %i", id)
        let result = try managedContext.fetch(request)
        if let objectToDelete = result.first {
            managedContext.delete(objectToDelete)
        }
        
        do {
            try managedContext.save()
        } catch {
            throw StorageManagerError.removeFailed
        }
    }
    
    
}
