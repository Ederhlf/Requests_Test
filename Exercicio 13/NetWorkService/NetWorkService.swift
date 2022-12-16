//
//  NetWorkService.swift
//  Exercicio 13
//
//  Created by franklin gaspar on 15/12/22.
//

import Foundation
import UIKit

enum  ResultError: Error {
    case badUrl
    case noData
    case invalidJson
}

class NetWorkManager {
    static let shared = NetWorkManager()
    
    struct Constant {
        static let newAPI = URL(
            string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=6321edd4dc824fdaab008fc14a97977c")
    }
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
                    
                    let result = try? newJSONDecoder().decode(News.self, from: data)
                    completion(.success(result?.articles ?? []))
                } catch {
                    print("Error info: \(error.localizedDescription)")
                    completion(.failure(.noData))
                    
                }
            }
            task.resume()
        }
    }

