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


//MARK: - Fetching Older version

/*
 func fetchData<T: Decodable, A: DataUrl>(with urlBuilder: A, as model: T.Type, onCompletion: @escaping (Result<T, FetchingError>) -> Void) {
     
     guard let request = urlBuilder.urlRequest else {
         onCompletion(.failure(FetchingError.urlComponentError))
         return
     }
     
     
     //older version
     let task = session.dataTask(with: request) { data, response, error in
         if let _ = error {
             onCompletion(.failure(FetchingError.requestError))
         }
         
         guard let response = response as? HTTPURLResponse else {
             onCompletion(.failure(FetchingError.responseError))
             return
         }
         
         guard (200...299).contains(response.statusCode) else {
             onCompletion(.failure(FetchingError.statusCodeError))
             return
         }
         
         if let data = data {
             //Parsing JSON
             let decoder = JSONDecoder()
             do {
                 let fetchedData = try decoder.decode(model, from: data)
                 DispatchQueue.main.async {
                     onCompletion(.success(fetchedData))
                 }
             } catch {
                 onCompletion(.failure(FetchingError.dataError))
             }
         }
     }
     //API call
     task.resume()
 }
 */
