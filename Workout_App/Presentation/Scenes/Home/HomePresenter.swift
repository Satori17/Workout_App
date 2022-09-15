//
//  HomePresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomePresentationLogic {
    func presentSavedWorkouts(response: HomeModel.GetSavedWorkouts.Response)
    func didFailPresentSavedWorkouts(withError message: StorageManagerError)
    func presentSavedWorkoutDetails(response: HomeModel.ShowSavedWorkoutDetails.Response)
}

final class HomePresenter {
    
    //MARK: - Clean Components
    weak var viewController: HomeDisplayLogic?
}

//TODO: - FIX research  Method dispatch

extension HomePresenter: HomePresentationLogic {
    
    func presentSavedWorkouts(response: HomeModel.GetSavedWorkouts.Response) {
        let displayedCoreWorkouts = getDisplayed(coreWorkouts: response.savedWorkouts)
        //filtering week days to populate on tableView
        let weekDays = Array(Set(displayedCoreWorkouts.map{ $0.weekDay }))
        let sortedWeekDays = sortWeekDays(weekDays) ?? []
        //sorting workouts by week day
        let sortedWorkouts = sortWorkoutsByWeekDay(displayedCoreWorkouts, sortedWeekDays: sortedWeekDays)
        //creating 2D array with 'same week day' logic
        let filteredCoreWorkouts = filterWorkoutsByWeekDay(workouts: sortedWorkouts)
        //ready to display!
        let viewModel = HomeModel.GetSavedWorkouts.ViewModel(displayedCoreWorkouts: filteredCoreWorkouts, weekDays: sortedWeekDays)
        viewController?.displaySavedWorkouts(viewModel: viewModel)
    }
    
    func didFailPresentSavedWorkouts(withError message: StorageManagerError) {
        viewController?.didFailDisplaySavedWorkouts(withError: message)
    }
    
    func presentSavedWorkoutDetails(response: HomeModel.ShowSavedWorkoutDetails.Response) {
        let viewModel = HomeModel.ShowSavedWorkoutDetails.ViewModel()
        viewController?.displaySavedWorkoutDetails(viewModel: viewModel)
    }
}

//MARK: - Helper Sorting & Filtering Methods

extension HomePresenter {
    
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
            if $0.last?.last?.weekDay.name == $1.weekDay.name {
                $0[$0.index(before: $0.endIndex)].append($1)
            } else {
                $0.append([$1])
            }
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
                name: $0.name ?? "",
                description: $0.descriptionText ?? "",
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
    
    //Category
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
    
    //Muscle
    private func formattedMuscles(ofWorkout workout: CoreWorkout, isMain: Bool) -> [MuscleDisplayable] {
        if isMain {
            //Muscles
            if let muscles = workout.muscles?.array as? [CoreMuscle] {
                let musclesArray = muscles.map({
                    MuscleDisplayable(
                        name: $0.name ?? "",
                        isFront: $0.isFront,
                        imageUrlMain: $0.imageUrlMain ?? "",
                        imageUrlSecondary: $0.imageUrlSecondary ?? ""
                    )
                })
                
                return musclesArray
            }
        } else {
            //Secondary muscles
            if let musclesSecondary = workout.musclesSecondary?.array as? [CoreMuscle] {
                let secondaryMusclesArray = musclesSecondary.map({
                    MuscleDisplayable(
                        name: $0.name ?? "",
                        isFront: $0.isFront,
                        imageUrlMain: $0.imageUrlMain ?? "",
                        imageUrlSecondary: $0.imageUrlSecondary ?? ""
                    )
                })
                
                return secondaryMusclesArray
            }
        }
        return []
    }
    
    //Equipment
    private func formattedEquipments(ofWorkout workout: CoreWorkout) -> [EquipmentDisplayable] {
        if let equipment = workout.equipments?.array as? [CoreEquipment]{
            let equipmentsArray = equipment.map({
                EquipmentDisplayable(
                    id: Int($0.id),
                    name: $0.name ?? ""
                )
            })
            
            return equipmentsArray
        }
        return []
    }
    
    //Language
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
    
    //Image
    private func formattedImages(ofWorkout workout: CoreWorkout) -> [ImageDisplayable] {
        if let images = workout.images?.array as? [CoreImage] {
            let imagesArray = images.map({
                ImageDisplayable(
                    id: Int($0.id),
                    image: $0.image ?? "",
                    isMain: $0.isMain
                )
            })
            
            return imagesArray
        }
        return []
    }
    
    //Comment
    private func formattedComments(ofWorkout workout: CoreWorkout) -> [CommentDisplayable] {
        if let comments = workout.comments?.array as? [CoreComment] {
            let commentsArray = comments.map({
                CommentDisplayable(
                    id: Int($0.id),
                    exercise: Int($0.exercise),
                    comment: $0.comment ?? ""
                )
            })
            
            return commentsArray
        }
        return []
    }
    
    //Week Day
    private func formattedWeekDays(ofWorkout workout: CoreWorkout) -> WeekDayModel {
        if let name = workout.weekDay?.name {
            return WeekDayModel(
                name: name,
                scheduledTime: workout.weekDay?.scheduledTime ?? "+"
            )
        }
        return WeekDayModel(name: "Unknown")
    }
}
