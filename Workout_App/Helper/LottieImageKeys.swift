//
//  LottieImageKeys.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 18.09.22.
//

import UIKit

private enum LottieImageKeys {
    static let dumbellIcon = "dumbell_animation"
    static let foodIcon = "food_animation"
    static let waterBottleIcon = "water_bottle"
    static let meditationIcon = "meditation"
    static let workoutIcon = "workout"
}

enum LottieKeys {
    static let dumbellIcon = (
        title: "Remember, the only difference between good and great is one more rep!",
        image: LottieImageKeys.dumbellIcon
    )
    static let foodIcon = (
        title: "Be on a healthy diet,",
        image: LottieImageKeys.foodIcon
    )
    static let waterBottleIcon = (
        title: "And hydrate yourself!",
        image: LottieImageKeys.waterBottleIcon
    )
    static let meditationIcon = (
        title: "Regular workout maintains your mental health and You'll never say 'Tomorrow' again",
        image: LottieImageKeys.meditationIcon
    )
    static let workoutIcon = (
        title: "Welcome to the Workout App! Your goal here is to keep consistent,",
        image: LottieImageKeys.workoutIcon
    )
}
