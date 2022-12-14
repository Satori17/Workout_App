//
//  HomeModels.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

typealias CoreWorkoutViewModel = HomeModel.GetSavedWorkouts.ViewModel.displayedCoreWorkout

enum HomeModel {
    
    //MARK: - Get Saved Workouts Use Case
    enum GetSavedWorkouts {
        
        struct Request {
            let index: Int
        }
        
        struct Response {
            let savedWorkouts: [CoreWorkout]
        }
        
        struct ViewModel {
            let displayedCoreWorkouts: [[displayedCoreWorkout]]
            let weekDays: [WeekDayModel]
            
            struct displayedCoreWorkout: Displayable {
                var id: Int
                var name: String
                var description: String
                var category: CategoryDisplayable
                var muscles: [MuscleDisplayable]
                var musclesSecondary: [MuscleDisplayable]
                var equipment: [EquipmentDisplayable]
                var language: LanguageDisplayable
                var images: [ImageDisplayable]
                var comments: [CommentDisplayable]
                var sets: Int
                var reps: Int
                var weekDay: WeekDayModel
                var isMissed: Bool
            }
        }
    }
    
    //MARK: - Show Saved Workout Details Use Case
    enum ShowSavedWorkoutDetails {
        
        struct Request {
            let savedWorkout: CoreWorkoutViewModel
        }        
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    //MARK: - Check User Permission Use Case
    enum checkUserPermission {
        
        struct Request {
            let granted: Bool
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
}
