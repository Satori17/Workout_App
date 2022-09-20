//
//  CategoryPresenter.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

protocol CategoryPresentationLogic {
    func presentCategories(response: CategoryModel.GetCategories.Response)
    func didFailPresentCategories(withError message: FetchingError)
    func presentCategoryWorkouts(response: CategoryModel.ShowCategoryWorkouts.Response)
}

final class CategoryPresenter {
    
    //MARK: - Clean Components
    weak var viewController: CategoryDisplayLogic?
}

//MARK: - Presentation Logic protocol
extension CategoryPresenter: CategoryPresentationLogic {
    
    func presentCategories(response: CategoryModel.GetCategories.Response) {
        let displayedCategories: [CategoryViewModel] = response.categories.map({
            CategoryViewModel(
                id: $0.id ?? 0,
                name: $0.name ?? CustomTitle.empty
            )
        })
        
        let viewModel = CategoryModel.GetCategories.ViewModel(displayedCategories: displayedCategories)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func didFailPresentCategories(withError message: FetchingError) {
        viewController?.didFailDisplayCategory(withError: message)
    }
    
    func presentCategoryWorkouts(response: CategoryModel.ShowCategoryWorkouts.Response) {        
        viewController?.displayCategoryWorkouts(viewModel: CategoryModel.ShowCategoryWorkouts.ViewModel())
    }
}
