//
//  NetWorkService.swift
//  Exercicio 13
//
//  Created by franklin gaspar on 15/12/22.
//

import Foundation

enum  ResultError: Error {
    case badUrl
    case noData
    case invalidJson
}

class NetWorkManager {
    static var shared = NetWorkManager()
    
    struct Constant {
        static let newAPI = URL(string: "http://127.0.0.1:8080")
        
        private init() {  }
        
        func getNews(completion: @escaping (Result<[Article],ResultError>) -> Void) {
            
            // Setup Url
            guard let url = Constant.newAPI else { return completion(.failure(.badUrl)) }
            
            // Creat Configuration
            let configuration = URLSessionConfiguration.default
            
            // Creat Session
            let session = URLSession(configuration: configuration)
            
            // Creat Task
            let task = session.dataTask(with: url) { data, response, error in
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data else { return  completion(.failure(.invalidJson
                      ))}
                
             // MARK:
                do {
                    let json = JSONDecoder()
                    let result = try json.decode(ResponseElement.self, from: data)
                    completion(.success(result.home.articles ?? []))
                } catch {
                    print("Error info: \(error.localizedDescription)")
                    completion(.failure(.noData))
                    
                }
            }
            task.resume()
        }
    }
}
