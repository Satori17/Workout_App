//
//  Request.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 15.08.22.
//

import UIKit

class Request {
    
    func url(requestType type: RequestType = .GET, urlComponent: inout URLComponents) -> URLRequest? {
        urlComponent.queryItems?.append(URLQueryItem(name: "format", value: "json"))
        guard let url = urlComponent.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        
        return request
    }
}
