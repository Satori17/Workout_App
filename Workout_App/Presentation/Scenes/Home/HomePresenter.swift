//
//  HomePresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomePresentationLogic {
    func presentCheckUserPermission(response: HomeModel.checkUserPermission.Response)
    func presentCoreWorkouts(response: HomeModel.GetSavedWorkouts.Response)
    func didFailPresentSavedWorkouts(withError message: StorageManagerError)
    func presentSavedWorkoutDetails(response: HomeModel.ShowSavedWorkoutDetails.Response)
    func presentRemoveWorkoutAlert(withMessage text: String)
    func didFailPresentRemoveWorkoutAlert(withError message: StorageManagerError)
    func didFailPresentToggleMissedWorkout(withError message: StorageManagerError)
}

final class HomePresenter {
    
    //MARK: - Clean Components
    weak var viewController: HomeDisplayLogic?
}

//MARK: - Presentation Logic protocol
extension HomePresenter: HomePresentationLogic {
    
    func presentCheckUserPermission(response: HomeModel.checkUserPermission.Response) {
        viewController?.displayCheckUserPermission(viewModel: HomeModel.checkUserPermission.ViewModel())
    }
    
    func presentCoreWorkouts(response: HomeModel.GetSavedWorkouts.Response) {
        let displayedCoreWorkouts = getDisplayed(coreWorkouts: response.savedWorkouts)
        let data = getFinalWorkoutsAndWeekDays(displayedWorkouts: displayedCoreWorkouts)
        let viewModel = HomeModel.GetSavedWorkouts.ViewModel(displayedCoreWorkouts: data.workouts, weekDays: data.weekDays)
        viewController?.displayCoreWorkouts(viewModel: viewModel)
    }
    
    func didFailPresentSavedWorkouts(withError message: StorageManagerError) {
        viewController?.didFailDisplaySavedWorkouts(withError: message)
    }
    
    func presentSavedWorkoutDetails(response: HomeModel.ShowSavedWorkoutDetails.Response) {
        let viewModel = HomeModel.ShowSavedWorkoutDetails.ViewModel()
        viewController?.displaySavedWorkoutDetails(viewModel: viewModel)
    }
    
    func presentRemoveWorkoutAlert(withMessage text: String) {
        viewController?.displayRemoveWorkoutAlert(withMessage: text)
    }
    
    func didFailPresentRemoveWorkoutAlert(withError message: StorageManagerError) {
        viewController?.didFailDisplayRemoveWorkoutAlert(withError: message)
    }
    
    func didFailPresentToggleMissedWorkout(withError message: StorageManagerError) {
        viewController?.didFailDisplayToggleMissedWorkout(withError: message)
    }
}

//MARK: - Helper Sorting & Filtering Methods
extension HomePresenter {
    
    private func getFinalWorkoutsAndWeekDays(displayedWorkouts: [CoreWorkoutViewModel]) -> (workouts: [[CoreWorkoutViewModel]], weekDays: [WeekDayModel]) {
        //filtering week days to populate on tableView
        let weekDays = Array(Set(displayedWorkouts.map{ $0.weekDay }))
        let sortedWeekDays = sortWeekDays(weekDays) ?? []
        //sorting workouts by week day
        let sortedWorkouts = sortWorkoutsByWeekDay(displayedWorkouts, sortedWeekDays: sortedWeekDays)
        //creating 2D array with "same week day" logic
        let filteredCoreWorkouts = filterWorkoutsByWeekDay(workouts: sortedWorkouts)
        
        return (filteredCoreWorkouts, sortedWeekDays)
    }
    
    private func sortWorkoutsByWeekDay(_ workouts: [CoreWorkoutViewModel], sortedWeekDays: [WeekDayModel]) -> [CoreWorkoutViewModel] {
        let sortedWorkouts = workouts.sorted(by: {
            if let firstItemIndex = sortedWeekDays.firstIndex(of: $0.weekDay),
               let secondItemIndex = sortedWeekDays.firstIndex(of: $1.weekDay) {
                return firstItemIndex < secondItemIndex
            }
            return false
        })
        
        return sortedWorkouts
    }
    
    private func sortWeekDays(_ weekDays: [WeekDayModel]) -> [WeekDayModel]? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Formatted.us_localeId)
        
        var correctOrder = formatter.weekdaySymbols
        if let first = correctOrder?.removeFirst() {
            correctOrder?.append(first)
        }
        let result = weekDays.sorted {
            if let firstItemIndex = correctOrder?.firstIndex(of: $0.name),
               let secondItemIndex = correctOrder?.firstIndex(of: $1.name) {
                return firstItemIndex < secondItemIndex
            }
            return false
        }
        return result
    }
    
    private func filterWorkoutsByWeekDay(workouts: [CoreWorkoutViewModel]) -> [[CoreWorkoutViewModel]] {
        let workoutsByWeek: [[CoreWorkoutViewModel]] = workouts.reduce(into: []) {
            $0.last?.last?.weekDay.name == $1.weekDay.name ? $0[$0.index(before: $0.endIndex)].append($1) : $0.append([$1])
        }
        return workoutsByWeek
    }
}

//MARK: - Helper Formatting Methods
extension HomePresenter {
    
    private func getDisplayed(coreWorkouts: [CoreWorkout]) -> [CoreWorkoutViewModel] {
        let displayedCoreWorkouts = coreWorkouts.map({
            CoreWorkoutViewModel(
                id: Int($0.id),
                name: $0.name ?? CustomTitle.empty,
                description: $0.descriptionText ?? CustomTitle.empty,
                category: formattedCategories(ofWorkout: $0),
                muscles: formattedMuscles(ofWorkout: $0, isMain: true),
                musclesSecondary: formattedMuscles(ofWorkout: $0, isMain: false),
                equipment: formattedEquipments(ofWorkout: $0),
                language: formattedLanguage(ofWorkout: $0),
                images: formattedImages(ofWorkout: $0),
                comments: formattedComments(ofWorkout: $0),
                sets: Int($0.sets),
                reps: Int($0.reps),
                weekDay: formattedWeekDays(ofWorkout: $0),
                isMissed: $0.isMissed
            )
        })
        
        return displayedCoreWorkouts
    }
    
    //MARK: - Categories
    private func formattedCategories(ofWorkout workout: CoreWorkout) -> CategoryDisplayable {
        if let category = workout.category {
            if let categoryName = category.name {
                return CategoryDisplayable(
                    id: Int(category.id),
                    name: categoryName
                )
            }
        }
        return CategoryDisplayable()
    }
    
    //MARK: - Muscles
    private func formattedMuscles(ofWorkout workout: CoreWorkout, isMain: Bool) -> [MuscleDisplayable] {
        if isMain {
            //Muscles
            if let muscles = workout.muscles?.array as? [CoreMuscle] {
                let musclesArray = muscles.map({
                    MuscleDisplayable(
                        name: $0.name ?? CustomTitle.empty,
                        isFront: $0.isFront,
                        imageUrlMain: $0.imageUrlMain ?? CustomTitle.empty,
                        imageUrlSecondary: $0.imageUrlSecondary ?? CustomTitle.empty
                    )
                })
                
                return musclesArray
            }
        } else {
            //Secondary muscles
            if let musclesSecondary = workout.musclesSecondary?.array as? [CoreMuscle] {
                let secondaryMusclesArray = musclesSecondary.map({
                    MuscleDisplayable(
                        name: $0.name ?? CustomTitle.empty,
                        isFront: $0.isFront,
                        imageUrlMain: $0.imageUrlMain ?? CustomTitle.empty,
                        imageUrlSecondary: $0.imageUrlSecondary ?? CustomTitle.empty
                    )
                })
                
                return secondaryMusclesArray
            }
        }
        return []
    }
    
    //MARK: - Equipment
    private func formattedEquipments(ofWorkout workout: CoreWorkout) -> [EquipmentDisplayable] {
        if let equipment = workout.equipments?.array as? [CoreEquipment]{
            let equipmentsArray = equipment.map({
                EquipmentDisplayable(
                    id: Int($0.id),
                    name: $0.name ?? CustomTitle.empty
                )
            })
            
            return equipmentsArray
        }
        return []
    }
    
    //MARK: - Language
    private func formattedLanguage(ofWorkout workout: CoreWorkout) -> LanguageDisplayable {
        if let language = workout.language {
            if let shortName = language.shortName,
               let fullName = language.fullName {
                return LanguageDisplayable(
                    id: Int(language.id),
                    shortName: shortName,
                    fullName: fullName
                )
            }
        }
        return LanguageDisplayable()
    }
    
    //MARK: - Images
    private func formattedImages(ofWorkout workout: CoreWorkout) -> [ImageDisplayable] {
        if let images = workout.images?.array as? [CoreImage] {
            let imagesArray = images.map({
                ImageDisplayable(
                    id: Int($0.id),
                    image: $0.image ?? CustomTitle.empty,
                    isMain: $0.isMain
                )
            })
            
            return imagesArray
        }
        return []
    }
    
    //MARK: - Comment
    private func formattedComments(ofWorkout workout: CoreWorkout) -> [CommentDisplayable] {
        if let comments = workout.comments?.array as? [CoreComment] {
            let commentsArray = comments.map({
                CommentDisplayable(
                    id: Int($0.id),
                    exercise: Int($0.exercise),
                    comment: $0.comment ?? CustomTitle.empty
                )
            })
            
            return commentsArray
        }
        return []
    }
    
    //MARK: - Week Day
    private func formattedWeekDays(ofWorkout workout: CoreWorkout) -> WeekDayModel {
        if let name = workout.weekDay?.name {
            return WeekDayModel(
                name: name,
                scheduledTime: workout.weekDay?.scheduledTime ?? CustomTitle.plus
            )
        }
        return WeekDayModel(name: CustomTitle.unknown)
    }
}
