//
//  WorkoutUrlBuilder.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 06.08.22.
//

import UIKit

class WorkoutUrlBuilder: Request, DataUrl {
    
    static let shared = WorkoutUrlBuilder()
    
    private(set) var urlString: String
    private(set) var urlRequest: URLRequest?
    private var limitValue = 419
    //limit- 419
    
    func withBaseUrl() {
        urlString = BaseUrl.url.rawValue
    }
    
    func withPath() {
        self.urlString += "exerciseinfo/?"
    }
    
    private func getComponents(withPath path: String) -> URLComponents? {
        var urlComponent = URLComponents(string: path)
        urlComponent?.queryItems = [
            URLQueryItem(name: "limit", value: "\(limitValue)")
        ]
     
        return urlComponent
    }
    
    override init() {
        self.urlString = ""
        super.init()
        withBaseUrl()
        withPath()
        if var components = getComponents(withPath: urlString) {
            self.urlRequest = url(urlComponent: &components)
        }
    }
    
}
