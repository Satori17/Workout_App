//
//  BaseUrl.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import Foundation

protocol DataUrl {
    var urlString: String { get }
    var urlRequest: URLRequest? { get }
    func withBaseUrl()
    func withPath()
}

enum BaseUrl: String {
    case url = "https://wger.de/api/v2/"
}
