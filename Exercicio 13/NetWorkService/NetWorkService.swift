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
    
//    func postRequest() {
//        let urlenconded = "user_name=carlos&password=123123"
//        let url = URL(string: "http://127.0.0.1:8080/login")!
//        var request = URLRequest(url: url)
//
//        request.httpMethod = "Post"
//        request.httpBody = urlenconded.data(using: .utf8)
//
//        let sesssion = URLSession(configuration: .default)
//
//        let task = sesssion.dataTask(with: request) {data,response, error in
//            if let data = data {
//                if let response = String(data: data, encoding: .utf8) {
//                    print(response)
//                }
//            }
//        }
//        task.resume()
//    }
//
    }

