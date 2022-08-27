//
//  Fetcher.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 02.08.22.
//

import UIKit

enum FetchingError: String, Error {
    case requestError = "Could not fetch data with request"
    case responseError = "There's an error in data response"
    case statusCodeError = "Unsuccessful response status code"
    case urlComponentError = "Error happened when attaching url components"
    case dataError = "Could not get data when decoding"
}


class Fetcher {
    
    static let shared = Fetcher()
    let session = URLSession(configuration: .default)
    
    func fetchData<T: Decodable, A: DataUrl>(with urlBuilder: A, as model: T.Type, onCompletion: @escaping (Result<T, FetchingError>) -> Void) {
        
        guard let request = urlBuilder.urlRequest else {
            onCompletion(.failure(FetchingError.urlComponentError))
            return
        }
        
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
}


//MARK: - opening urls in browser webview

//let defaultURL = "https://store.steampowered.com/news/"
//let selectedArticleURL = URL(string: defaultURL)!
//let safariVC = SFSafariViewController(url: selectedArticleURL)
//
//self.present(safariVC, animated: true)



//MARK: - Fetching muscle activity areas
//    guard let url = URL(string: "https://wger.de/static/images/muscles/secondary/muscle-10.svg") else { return }
//    newImage.sd_setImage(with: url)
