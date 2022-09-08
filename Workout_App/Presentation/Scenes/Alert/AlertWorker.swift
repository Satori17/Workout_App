//
//  AlertWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

class AlertWorker {
    
    func fetchWorkoutIntensityData() -> (sets: [String], reps: [String], weekDays: [String]) {
        let sets = Array(1...20).map { String($0) }
        let reps = Array(1...50).map { String($0)}
        let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        return (sets, reps, weekDays)
    }
}
