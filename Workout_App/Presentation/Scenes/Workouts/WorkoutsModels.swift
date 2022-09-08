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
        
        struct Request {
            let categoryId: Int
        }
        
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














/*
 typealias WorkoutViewModel = WorkoutModel.ViewModel.DisplayedWorkout
 typealias WorkoutCategoryModel = WorkoutModel.ViewModel.displayedCategory
 typealias MuscleModel = WorkoutModel.ViewModel.Muscle
 typealias EquipmentModel = WorkoutModel.ViewModel.Equipment
 typealias LanguageModel = WorkoutModel.ViewModel.Language
 typealias LicenseModel = WorkoutModel.ViewModel.License
 typealias ImageModel = WorkoutModel.ViewModel.Image
 typealias CommentModel = WorkoutModel.ViewModel.Comment
 */


/*
 var displayedWorkouts: [displayedWorkout]
 
 struct displayedWorkout {
 let id: Int
 let name: String
 var description: String
 let category: Category
 let muscles, musclesSecondary: [Muscle]
 let equipment: [Equipment]
 let language: Language
 let license: License
 let licenseAuthor: String
 let images: [Image]
 let comments: [Comment]
 let variations: [WorkoutViewModel]
 }
 
 //category
 struct Category {
 let id: Int
 let name: String
 
 init(id: Int, name: String) {
 self.id = id
 self.name = name
 }
 
 init() {
 id = 0
 name = "error getting category name"
 }
 }
 
 //muscle
 struct Muscle {
 let name: String
 let isFront: Bool
 let imageUrlMain, imageUrlSecondary: String
 }
 
 //equipment
 struct Equipment {
 let id: Int
 let name: String
 }
 
 //language
 struct Language {
 let id: Int
 let shortName, fullName: String
 
 init(id: Int, shortName: String, fullName: String) {
 self.id = id
 self.shortName = shortName
 self.fullName = fullName
 }
 
 init() {
 id = 0
 shortName = "error getting shortName"
 fullName = "error getting fullName"
 }
 }
 
 //license
 struct License {
 let licenseInfo: Language
 let url: URL
 
 init(licenseInfo: Language, url: URL) {
 self.licenseInfo = licenseInfo
 self.url = url
 }
 
 init() {
 licenseInfo = Language()
 url = URL(string: "https://via.placeholder.com/600x400?text=Error+Getting+License")!
 }
 }
 
 //image
 struct Image {
 let id: Int
 let image: String
 let isMain: Bool
 }
 
 //comment
 struct Comment {
 let id, exercise: Int
 let comment: String
 }
 
 */
