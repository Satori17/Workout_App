//
//  AlertWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 07.09.22.
//

import UIKit

final class AlertWorker {
    
    private let sets = Array(1...20).map { String($0) }
    private let reps = Array(1...50).map { String($0) }
    private let weekDays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]
    
    func fetchWorkoutIntensityData() -> (sets: [String], reps: [String], weekDays: [String]) {
        (sets, reps, weekDays)
    }
}
