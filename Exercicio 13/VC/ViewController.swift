//
//  ViewController.swift
//  Exercicio 
//
//  Created by franklin gaspar on 25/09/22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var myView: View?
    let search = UISearchBar()
    
    override func loadView() {
        super.loadView()
        myView = View()
        view = myView
        myView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Test"
        navigationItem.searchController?.view = search
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.link]
        navigationController?.navigationBar.backgroundColor = .orange
        view.backgroundColor = .link

//        NetWorkManager.shared.getNews {  result in
//            switch result {
//            case .success(let response):
//                for item  in response {
//                    self.myView?.newsData.append(item)
//                }
//
//            case .failure(let error):
//                print(error.self)
//            }
//        }
        NetWorkManager.shared.upLoadTest()
    }
}

extension ViewController: ViewDelegate {
    func alertAcion() {
        let alert = UIAlertController(title: "Did Select", message: "Test", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    func loadNews() {
        guard let url = URL(
            string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=6321edd4dc824fdaab008fc14a97977c"
        ) else { return }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    
                    guard let data = data else { return }
                    
                    do {
                        let cep = try? newJSONDecoder().decode(News.self, from: data)
                        DispatchQueue.main.async {
                            self.myView?.newsData = cep?.articles ?? []
                            self.myView?.tableView.reloadData()
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("Status inválido do servidor, Status Code: \(response.statusCode)")
                }
            } else {
                print(error!.localizedDescription)
            }
        }.resume()
    }
}
