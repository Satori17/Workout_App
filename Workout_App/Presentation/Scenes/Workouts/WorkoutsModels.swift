//
//  WorkoutsModels.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

typealias WorkoutViewModel = WorkoutModel.GetWorkouts.ViewModel.DisplayedWorkout

enum WorkoutModel {
    
    //MARK: - Get Workouts Use Case
    
    enum GetWorkouts {
        
        struct Request { }
        
        struct Response {
            let workouts: [Workout]
        }
        
        struct ViewModel {
            var displayedWorkouts: [DisplayedWorkout]
            
            struct DisplayedWorkout: Displayable {
                var id: Int
                var name: String
                var description: String
                var category: CategoryDisplayable
                var muscles: [MuscleDisplayable]
                var musclesSecondary: [MuscleDisplayable]
                var equipment: [EquipmentDisplayable]
                var language: LanguageDisplayable
                var license: LicenseDisplayable
                var licenseAuthor: String
                var images: [ImageDisplayable]
                var comments: [CommentDisplayable]
                var variations: [Displayable]
            }
        }
    }
    
    //MARK: - Show Workout Details Use Case
    
    enum ShowWorkoutDetails {
        
        struct Request {
            let workout: WorkoutViewModel
            let isAnimated: Bool
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    //MARK: - Show Save Alert Use Case
    
    enum ShowSaveAlert {
        
        struct Request {
            let workout: WorkoutViewModel
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
}
