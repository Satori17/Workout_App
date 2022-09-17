//
//  Fetcher.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

class Fetcher {
    
    static let shared = Fetcher()
    let session = URLSession(configuration: .default)
    
    func fetchData<T: Decodable, A: DataUrl>(with urlBuilder: A, as model: T.Type) async throws -> T {
        
        guard let request = urlBuilder.urlRequest else { throw FetchingError.urlComponentError }
        
        let (data,response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw FetchingError.responseError }
        guard (200...299).contains(response.statusCode) else { throw FetchingError.statusCodeError }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(model, from: data)
            
        } catch {
            throw FetchingError.dataError
        }
    }
}
