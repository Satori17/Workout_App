//
//  CategoryUrlBuilder.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

class CategoryUrlBuilder: DataUrl {
    
    static let shared = CategoryUrlBuilder()
    
    private(set) var urlString: String
    
    func withBaseUrl() {
        urlString = BaseUrl.url.rawValue
    }
    
    private func withPath() {
        self.urlString += "exercisecategory/?"
    }
    
    func withFormat() {
        self.urlString += BaseUrl.format.rawValue
    }
    
    init() {
        self.urlString = ""
        withBaseUrl()
        withPath()
        withFormat()
    }
    
}
