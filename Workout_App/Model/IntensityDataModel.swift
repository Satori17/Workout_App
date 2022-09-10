//
//  IntensityDataModel.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 09.09.22.
//

import UIKit

struct IntensityData {
    private let sets: [String]
    private let reps: [String]
    private let weekDays: [String]
    
    init() {
        self.sets = Array(1...20).map { String($0) }
        self.reps = Array(1...50).map { String($0) }
        self.weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    }
    
    func getIntensityData() -> (sets: [String], reps: [String], weekDays: [String]) {
        (sets, reps, weekDays)
    }
    
    func getWeekDays() -> [String] {
        weekDays
    }
    
}
