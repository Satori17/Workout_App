//
//  AlertModels.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

enum AlertModel {
    
    // MARK: Get Workout Intensity Data Use case
    enum GetWorkoutIntensity {
        
        struct Request { }
        
        struct Response {
            let intensityData: (sets: [String], reps: [String], weekDays: [String])
        }
        
        struct ViewModel {
            let sets: [String]
            let reps: [String]
            let weekDays: [String]
        }
    }
    
    //MARK: - Save Workout Use Case
    enum SaveWorkout {
        
        struct Request {
            let sets: Int
            let reps: Int
            let weekDay: WeekDayModel
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    //MARK: - Show Failed Alert Use Case
    enum ShowAlert {
        
        struct Request { }
        
        struct Response {
            let alertText: String
            let success: Bool
        }
        
        struct ViewModel {
            let alertText: String
            let success: Bool
        }
    }
    
    //MARK: - Show Rep Range Alert
    enum ShowRepRangeAlert {
        
        struct Request {
            let repCount: Int
        }
        
        struct Response {
            let text: String
            let textColor: UIColor?
        }
        
        struct ViewModel {
            let text: String
            let textColor: UIColor?
        }
    }
}
