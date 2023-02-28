//
//  View.swift
//  Exercicio 
//
//  Created by franklin gaspar on 12/10/22.
//

import Foundation
import UIKit

protocol ViewDelegate: AnyObject {
    func alertAcion()
}
 
class View: UIView {
    // MARK: Property
    let cellSpacingHeight: CGFloat = 30
    var activityView: UIActivityIndicatorView?
    weak var delegate: ViewDelegate?
//    var newsData: [Article] = [] {
//        didSet {
//          DispatchQueue.main.async {
//              self.tableView.reloadData()
//            self.hideActivityIndicator()
//            }
//        }
//    }
//
    var newsDataEntity: [NewsDataEntity] = DataManager.shared.collectionNewsData() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }
    
    // MARK: Views
    let tableView = UITableView()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        showActivityIndicator()
        layoutBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        guard let activityView = activityView else { return }
        tableView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        activityView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activityView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 200) .isActive = true
        activityView.startAnimating()
    }
    
    func hideActivityIndicator() {
        guard  let activityView = activityView else { return }
        
        activityView.stopAnimating()
    }
    
    func layoutBtn() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewNewsCell.self, forCellReuseIdentifier: "cell")
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor) .isActive = true
        tableView.tableFooterView = .init(frame: .zero)
    }
}

extension View: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataEntity.count ?? Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewNewsCell
       
        let dataAPI = newsDataEntity[indexPath.row]
        cell?.author.text = " Autor:  \(dataAPI.author!)"
        cell?.content.text = dataAPI.content
    
        guard let url = dataAPI.urlToImage else { return UIView() as! UITableViewCell }
        guard let urls = URL(string: url) else { return UITableViewCell() }
        let data = try? Data(contentsOf: urls)
        cell?.imageLink.image = UIImage(data: data ?? Data())

        return cell ?? TableViewNewsCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
}
