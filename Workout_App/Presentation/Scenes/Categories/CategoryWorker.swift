//
//  CategoryWorker.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

protocol CategoryWorkerProtocol {
    func fetchCategories() async throws -> [Category]
}

class CategoryWorker: CategoryWorkerProtocol {
    
    func fetchCategories() async throws -> [Category] {
        let data = try await Fetcher.shared.fetchData(with: CategoryUrlBuilder.shared, as: WorkoutData<Category>.self)
        guard let categories = data.results else { throw FetchingError.dataError }
        
        return categories
    }
    
}
