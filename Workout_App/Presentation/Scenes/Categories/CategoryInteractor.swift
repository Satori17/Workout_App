//
//  CategoryInteractor.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

protocol CategoryBusinessLogic: AnyObject {
    func getCategories(request: CategoryModel.GetCategories.Request)
    func showCategoryWorkouts(request: CategoryModel.ShowCategoryWorkouts.Request)
}

protocol CategoryDataStore {
    var categoryId: Int? { get }
    var categoryName: String? { get }
    
}

class CategoryInteractor: CategoryDataStore {
    //clean components
    var presenter: CategoryPresentationLogic?
    private var worker: CategoryWorker?
    private(set) var categoryId: Int?
    private(set) var categoryName: String?
    
}

extension CategoryInteractor: CategoryBusinessLogic {
    
    func getCategories(request: CategoryModel.GetCategories.Request) {
        worker = CategoryWorker()
        Task {
            do {
                let categories = try await worker?.fetchCategories()
                DispatchQueue.main.async { [weak self] in
                    if let categories = categories {
                        let response = CategoryModel.GetCategories.Response(categories: categories)
                        self?.presenter?.presentCategories(response: response)
                    }
                }
            } catch(let error) {
                self.presenter?.didFailPresentCategories(withError: error as! FetchingError)
            }
        }
    }
    
    func showCategoryWorkouts(request: CategoryModel.ShowCategoryWorkouts.Request) {
        self.categoryId = request.id
        self.categoryName = request.name
        let response = CategoryModel.ShowCategoryWorkouts.Response()
        presenter?.showCategoryWorkouts(response: response)
    }
    
}
