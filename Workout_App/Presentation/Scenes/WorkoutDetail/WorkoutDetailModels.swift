//
//  WorkoutDetailModels.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

enum WorkoutDetailModel {
    
    //MARK: - Get Workout Details Use Case
    
    enum GetWorkoutDetails {
        
        struct Request { }
        
        struct Response {
            let workout: Displayable
        }
        
        struct ViewModel {
            let workout: Displayable
            
        }
    }
    
    //MARK: - Get License Use Case
    
    enum GetLicense {
        
        struct Request { }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    //MARK: - Show Save Alert Use Case
    
    enum ShowSaveAlert {
        
        struct Request { }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
}
