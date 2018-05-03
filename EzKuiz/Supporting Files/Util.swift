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
    
    static func downloadImage(url: URL, completition: @escaping (UIImage) -> ()) {
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let e = error {
                NSLog("Error downloading image: \(e)\nfrom:\"\(url)\"")
            } else {
                
                if let res = response as? HTTPURLResponse {
                    
                    NSLog("Downloaded image with response code \(res.statusCode)")
                    
                    if let imageData = data {
                        
                        completition(UIImage(data: imageData)!)
                    } else {
                        NSLog("Couldn't get image: Image is nil")
                    }
                } else {
                    NSLog("Couldn't get response code for some reason")
                }
            }
        }).resume()
    }
}

