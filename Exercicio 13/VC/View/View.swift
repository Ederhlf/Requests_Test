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
    var newsData: [Article]?
    let cellSpacingHeight: CGFloat = 30

    weak var delegate: ViewDelegate?
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}

extension View: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData?.count ?? Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewNewsCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Testes"
            } else {
        guard let dataAPI = newsData?[indexPath.section] else { return UITableViewCell() }
        cell?.author.text = " Autor:  \(dataAPI.author!)"
        cell?.content.text = dataAPI.content
    
        guard let url = dataAPI.urlToImage else { return UIView() as! UITableViewCell }
        guard let urls = URL(string: url) else { return UITableViewCell() }
        let data = try? Data(contentsOf: urls)
        cell?.imageLink.image = UIImage(data: data ?? Data())
        }
    }
        return cell ?? TableViewNewsCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    // Set the spacing between sections
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return cellSpacingHeight
       }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
       }
}
