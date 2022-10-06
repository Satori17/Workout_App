//
//  CategoryUrlBuilder.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

final class CategoryUrlBuilder: Request, DataUrl {
    
    static let shared = CategoryUrlBuilder()
    
    private(set) var urlString: String
    private(set) var urlRequest: URLRequest?
    private(set) var component: URLComponents?
    
    func withBaseUrl() {
        urlString = BaseUrl.url.rawValue
    }
    
    func withPath() {
        self.urlString += URLPath.category
    }
    
    override init() {
        self.urlString = ""
        super.init()
        withBaseUrl()
        withPath()
        component = URLComponents(string: urlString)
        if var component = component {
            self.urlRequest = url(urlComponent: &component)
        }
    }
}
