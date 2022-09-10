//
//  AlertWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

final class AlertWorker {
    
    let intensityData = IntensityData()
    
    func fetchWorkoutIntensityData() -> (sets: [String], reps: [String], weekDays: [String]) {
        intensityData.getIntensityData()
    }
}
