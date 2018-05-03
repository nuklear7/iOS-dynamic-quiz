//
//  Util.swift
//  Globe
//
//  Created by Dávid Mohácsi on 2018. 04. 27..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit
import CoreData

class Util {
    
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in completion(data, response, error)}.resume()
    }
    
    static func clearCoreData(entities: [String]) {
        
        // let entities = ["Article", "ArticleContent"]
        
        let managedObjectContext = AppDelegate.viewContext
        
        entities.forEach{
            let deleteArticleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: $0)
            let deleteArticleRequest = NSBatchDeleteRequest(fetchRequest: deleteArticleFetch)
            
            do {
                try managedObjectContext.execute(deleteArticleRequest)
                try managedObjectContext.save()
            } catch {
                NSLog("There was an error")
            }
        }
    }
    
    static func getFileContentAsString(filename: String, ext: String) -> String {
        
        var contents = ""
        
        if let filepath = Bundle.main.path(forResource: filename, ofType: ext) {
            do {
                contents = try String(contentsOfFile: filepath)
            } catch {
                NSLog("File parsing error: \(error)")
            }
        } else {
            NSLog("File not found!")
        }
        
        return contents
    }
}

