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
        
        struct Request { }
        
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
    
    //MARK: - Get Missed Workouts Use Case
    enum getMissedWorkouts {
        
        struct Request { }
        
        struct Response {
            let missedWorkouts: [CoreWorkout]
        }
        
        struct ViewModel {
            let displayedMissedWorkouts: [[CoreWorkoutViewModel]]
            let missedWorkoutWeekDays: [WeekDayModel]            
        }
    }
}
