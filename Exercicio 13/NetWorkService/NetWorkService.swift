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
    
    // UpLoading
   
    // Constants
    struct Constant {
        static let newAPI = URL(
            string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=6321edd4dc824fdaab008fc14a97977c")
    }
    
        // MARK: Init
    private  init() {  }
     
    // MARK: Request Api
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
    
    // MARK: About Policy Cache
    func rermoveAllCacheResponse() {
    URLCache.shared.removeAllCachedResponses()
    }
    
    func fetch(title: String, policy: URLRequest.CachePolicy) {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/cache")!)
        request.setValue(title, forHTTPHeaderField: "cache-policy")
        request.cachePolicy = policy

        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let headers = httpResponse.allHeaderFields
            let etag = headers["Etag"] ?? "-"
            let cc = headers["Cache-Control"] ?? "-"
            
            print("\(title)".prefix(30), String(data: data!, encoding: .utf8)!, "Status Code:", httpResponse.statusCode, "Etag:", etag, "Cache-Control:",cc)
            
        }.resume()
    }
    
    func timer(_ timeInterval: Double, _ repeats: Bool) -> Timer {
        return Timer(timeInterval: timeInterval, repeats: repeats) { _ in
            self.fetch(title: "useProtocolCachePolicy", policy: .useProtocolCachePolicy)
        //    fetch(title: "returnCacheDataElseLoad", policy: .returnCacheDataElseLoad)
        //    fetch(title: "reloadIgnoringLocalCacheData", policy: .reloadIgnoringLocalCacheData)
        //    fetch(title: "returnCacheDataDontLoad", policy: .returnCacheDataDontLoad)
        }
    }
   
    func runLoop() {
      RunLoop.current.add(timer(1, true), forMode: .common)
      RunLoop.current.run()
    }
    

    func upLoadTest() {
        let image = UIImage(named: "WhatsApp Image 2022-08-12 at 11.07.38-2.jpeg")
//        let fileURL = URL(string: "file://Users/franklingaspar/Downloads/perfil.jpeg")!
        let imageData  = image?.jpegData(compressionQuality: 1.0)!
        let upload = URL(string: "http://127.0.0.1:8080/upload")!

        var request =  URLRequest(url: upload)
        request.httpMethod = "Post"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        //MARK: Cabecalho de uma requisicao de UpLoad
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"photo\";filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let session = URLSession(configuration: .default, delegate: SessionDelegate(), delegateQueue: OperationQueue.main)
        
      //  let task = URLSession.shared.uploadTask(with: request, from: data) {(data,response,error) in
        let task = session.uploadTask(with: request, from: data) {(data,response,error) in
            let response = String(data: data!, encoding: .utf8)
            if let error = error {
                print(error.localizedDescription)
            }

            print("response ==> \(String(describing: response))")
        }
        task.resume()

    }
}

class SessionDelegate: NSObject, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let progress = round(Float(totalBytesSent) / Float(totalBytesExpectedToSend) * 100)
        
        print("carregando: \(progress) %")
    }
}
