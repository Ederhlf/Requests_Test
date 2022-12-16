//
//  Article.swift
//  Exercicio 13
//
//  Created by franklin gaspar on 15/12/22.
//

import Foundation
import UIKit

struct Article: Codable {
    let source: Source?
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source
        case author, title
        case description
        case url, urlToImage, publishedAt, content
    }
}
