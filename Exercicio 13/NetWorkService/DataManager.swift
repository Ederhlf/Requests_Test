//
//  DataManager.swift
//  Exercicio 13
//
//  Created by franklin gaspar on 23/02/23.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Exercicio_13")
        container.loadPersistentStores { nsPersistentStoreDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        let container = persistentContainer.viewContext
        if container.hasChanges {
            
            do {
                try container.save()
                
            } catch let error as NSError? {
                fatalError("Unresolved error \(error), \(error?.userInfo)")
            }
        }
    }
    
    func getArticles(autor: String, content: String, urlToImage: String) -> NewsDataEntity {
//        let fetchRequest: NSFetchRequest<NewsDataEntity> = NewsDataEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "", <#T##args: CVarArg...##CVarArg#>)
        
        let newsdata = NewsDataEntity(context: viewContext)
        newsdata.author = autor
        newsdata.content = content
        newsdata.urlToImage = urlToImage
        
        return newsdata
    }
    
    func collectionNewsData() -> [NewsDataEntity] {
        let fetchRequest: NSFetchRequest<NewsDataEntity> = NewsDataEntity.fetchRequest()
        var newsData: [NewsDataEntity] = []
        
        do {
            newsData = try viewContext.fetch(fetchRequest)
            return newsData
            
        } catch let error as NSError {
            return []
        }
        
    }
}
