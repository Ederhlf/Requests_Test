//
//  Source.swift
//  Exercicio 13
//
//  Created by franklin gaspar on 15/12/22.
//

import Foundation
import UIKit

struct Source: Codable {
    let id: ID
    let name: Name
}

enum ID: String, Codable {
    case techcrunch
}

enum Name: String, Codable {
    case techCrunch = "TechCrunch"
}
