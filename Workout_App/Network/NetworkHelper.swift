//
//  NetworkHelper.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 20.09.22.
//

import UIKit

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

enum URLPath {
    static let category = "exercisecategory/?"
    static let workout = "exerciseinfo/?"
}

enum Components {
    static let limit = "limit"
}
