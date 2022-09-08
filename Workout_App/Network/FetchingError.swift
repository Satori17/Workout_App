//
//  FetchingError.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import Foundation

enum FetchingError: String, Error {
    case requestError = "Could not fetch data with request"
    case responseError = "There's an error in data response"
    case statusCodeError = "Unsuccessful response status code"
    case urlComponentError = "Error happened when attaching url components"
    case dataError = "Could not get data when decoding"
}
