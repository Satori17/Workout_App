//
//  DataModel.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

//MARK: - Workout Data
struct WorkoutData<T: Decodable>: Decodable {
    let results: [T]?
}
