//
//  WorkoutsPresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

protocol WorkoutsPresentationLogic {
    func presentWorkouts(response: WorkoutModel.GetWorkouts.Response)
    func didFailPresentWorkouts(withError message: FetchingError)
    func presentWorkoutDetails(response: WorkoutModel.ShowWorkoutDetails.Response)
    func presentSaveAlert(response: WorkoutModel.ShowSaveAlert.Response)
}

class WorkoutsPresenter {
    weak var viewController: WorkoutsDisplayLogic?
    
}


extension WorkoutsPresenter: WorkoutsPresentationLogic {
    
    func presentWorkouts(response: WorkoutModel.GetWorkouts.Response) {
        
        let displayedWorkouts = response.workouts.map({
            WorkoutViewModel(id: $0.id ?? 0,
                             name: $0.name ?? "",
                             description: formattedDescriptionnn(ofWorkout: $0),
                             category: formattedCategories(ofWorkout: $0),
                             muscles: formattedMuscles(ofWorkout: $0, isMain: true),
                             musclesSecondary: formattedMuscles(ofWorkout: $0, isMain: false),
                             equipment: formattedEquipments(ofWorkout: $0),
                             language: formattedLanguage(ofWorkout: $0),
                             license: formattedLicense(ofWorkout: $0),
                             licenseAuthor: $0.licenseAuthor ?? "",
                             images: formattedImages(ofWorkout: $0),
                             comments: formattedComments(ofWorkout: $0),
                             variations: formattedVariations(from: response, ofWorkout: $0))
        })
        
        let viewModel = WorkoutModel.GetWorkouts.ViewModel(displayedWorkouts: displayedWorkouts)
        viewController?.displayWorkouts(viewModel: viewModel)
    }
    
    func didFailPresentWorkouts(withError message: FetchingError) {
        viewController?.didFailDisplayWorkouts(withError: message)
    }
    
    func presentWorkoutDetails(response: WorkoutModel.ShowWorkoutDetails.Response) {
        viewController?.displayWorkoutDetails(viewModel: WorkoutModel.ShowWorkoutDetails.ViewModel())
    }
    
    func presentSaveAlert(response: WorkoutModel.ShowSaveAlert.Response) {
        viewController?.displaySaveAlert(viewModel: WorkoutModel.ShowSaveAlert.ViewModel())
    }
    
}


//MARK: - Helper Formatting Methods

extension WorkoutsPresenter {
    
    //formatted string to clear out html symbols
    private func formattedDescriptionnn(ofWorkout workout: Workout) -> String {
        if let description = workout.resultDescription {
            return description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }
        return ""
    }
    
    //categories
    private func formattedCategories(ofWorkout workout: Workout) -> CategoryDisplayable {
        if let category = workout.category {
            if let categoryId = category.id,
               let categoryName = category.name {
                return CategoryDisplayable(id: categoryId, name: categoryName)
            }
        }
        return CategoryDisplayable()
    }
    
    //muscles
    private func formattedMuscles(ofWorkout workout: Workout, isMain: Bool) -> [MuscleDisplayable] {
        let muscleBaseUrl = "https://wger.de"
        
        if isMain {
            //Muscles
            if let muscles = workout.muscles {
                let musclesArray: [MuscleDisplayable] = muscles.map({
                    MuscleDisplayable(name: $0.name ?? "",
                                      isFront: $0.isFront ?? false,
                                      imageUrlMain: muscleBaseUrl + ($0.imageURLMain ?? ""),
                                      imageUrlSecondary: muscleBaseUrl + ($0.imageURLSecondary ?? ""))
                })
                
                return musclesArray
            }
        } else {
            //Secondary muscles
            if let musclesSecondary = workout.musclesSecondary {
                let secondaryMusclesArray: [MuscleDisplayable] = musclesSecondary.map({
                    MuscleDisplayable(name: $0.name ?? "",
                                      isFront: $0.isFront ?? false,
                                      imageUrlMain: muscleBaseUrl + ($0.imageURLMain ?? ""),
                                      imageUrlSecondary: muscleBaseUrl + ($0.imageURLSecondary ?? ""))
                })
                
                return secondaryMusclesArray
            }
        }
        return []
    }
    
    //equipments
    private func formattedEquipments(ofWorkout workout: Workout) -> [EquipmentDisplayable] {
        if let equipment = workout.equipment {
            let equipmentsArray = equipment.map({
                EquipmentDisplayable(id: $0.id ?? 0,
                                     name: $0.name ?? "")
            })
            
            return equipmentsArray
        }
        return []
    }
    
    //language
    private func formattedLanguage(ofWorkout workout: Workout) -> LanguageDisplayable {
        if let language = workout.language {
            if let languageId = language.id,
               let shortName = language.shortName,
               let fullName = language.fullName {
                return LanguageDisplayable(id: languageId,
                                           shortName: shortName,
                                           fullName: fullName)
            }
        }
        return LanguageDisplayable()
    }
    
    //license
    private func formattedLicense(ofWorkout workout: Workout) -> LicenseDisplayable {
        if let license = workout.license {
            if let licenseId = license.id,
               let shortName = license.shortName,
               let fullName = license.fullName,
               let url = license.url {
                return LicenseDisplayable(licenseInfo: LanguageDisplayable(id: licenseId,
                                                                           shortName: shortName,
                                                                           fullName: fullName),
                                          url: url)
            }
        }
        return LicenseDisplayable()
    }
    
    //images
    private func formattedImages(ofWorkout workout: Workout) -> [ImageDisplayable] {
        var imagesArray = [ImageDisplayable]()
        let imagePlaceholder = "image_placeholder"
        
        if let images = workout.images {
            let mainImage = images.first?.image ?? imagePlaceholder
            let secondaryImage = (mainImage != imagePlaceholder ? images.last?.image : "") ?? ""
            
            images.forEach({
                if let id = $0.id,
                   let isMain = $0.isMain {
                    isMain ? imagesArray.append(ImageDisplayable(id: id, image: mainImage, isMain: isMain)) : imagesArray.append(ImageDisplayable(id: id, image: secondaryImage, isMain:isMain))
                }
            })
            if images.isEmpty {
                imagesArray.append(ImageDisplayable(id: 0, image: imagePlaceholder, isMain: true))
            }
        }
        return imagesArray
    }
    
    //comments
    private func formattedComments(ofWorkout workout: Workout) -> [CommentDisplayable] {
        if let comments = workout.comments {
            let commentsArray = comments.map({
                CommentDisplayable(id: $0.id ?? 0,
                                   exercise: $0.exercise ?? 0,
                                   comment: "🔘 \($0.comment ?? "")")
            })
            
            return commentsArray
        }
        
        return []
    }
    
    //variations
    private func formattedVariations(from response: WorkoutModel.GetWorkouts.Response, ofWorkout workout: Workout) -> [WorkoutViewModel] {
        var variationsArray = [WorkoutViewModel]()
        
        if let variations = workout.variations {
            variations.forEach({ variation in
                let workoutIndex = response.workouts.firstIndex(where: { $0.id == variation })
                if let workoutIndex = workoutIndex {
                    let currentWorkout = response.workouts[workoutIndex]
                    if let id = currentWorkout.id,
                       let name = currentWorkout.name,
                       let licenseAuthor = currentWorkout.licenseAuthor,
                       currentWorkout.id != workout.id {
                        variationsArray.append(WorkoutViewModel(id: id,
                                                                name: name,
                                                                description: formattedDescriptionnn(ofWorkout: currentWorkout),
                                                                category: formattedCategories(ofWorkout: currentWorkout),
                                                                muscles: formattedMuscles(ofWorkout: currentWorkout, isMain: true),
                                                                musclesSecondary: formattedMuscles(ofWorkout: currentWorkout, isMain: false),
                                                                equipment: formattedEquipments(ofWorkout: currentWorkout),
                                                                language: formattedLanguage(ofWorkout: currentWorkout),
                                                                license: formattedLicense(ofWorkout: currentWorkout),
                                                                licenseAuthor: licenseAuthor,
                                                                images: formattedImages(ofWorkout: currentWorkout),
                                                                comments: formattedComments(ofWorkout: currentWorkout),
                                                                variations: []))
                    }
                }
            })
        }
        return variationsArray
    }
    
}
