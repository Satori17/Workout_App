//
//  CategoryModels.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 30.07.22.
//

import UIKit

typealias CategoryViewModel = CategoryModel.GetCategories.ViewModel.displayedCategory

enum CategoryModel {
    
    //MARK: - Get Categories Use Case
    
    enum GetCategories {
        
        struct Request {}
        
        struct Response {
            let categories: [Category]
        }
        
        struct ViewModel {
            var displayedCategories: [displayedCategory]
            
            struct displayedCategory {
                let id: Int
                let name: String
                var image: UIImage {
                    if let imagePath = UIImage(named: name)?.resizeImage(targetSize: 400) {
                        return imagePath
                    }
                    return UIImage()
                }
            }
        }
        
    }
    
    //MARK: - Show Category Workouts Use Case
    
    enum ShowCategoryWorkouts {
        
        struct Request {
            let id: Int
            let name: String
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
}
