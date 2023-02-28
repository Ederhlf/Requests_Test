//
//  NewsDataEntity+CoreDataProperties.swift
//  Exercicio 13
//
//  Created by franklin gaspar on 23/02/23.
//
//

import Foundation
import CoreData


extension NewsDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsDataEntity> {
        return NSFetchRequest<NewsDataEntity>(entityName: "NewsDataEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var author: String?
    @NSManaged public var urlToImage: String?

}

extension NewsDataEntity : Identifiable {

}
