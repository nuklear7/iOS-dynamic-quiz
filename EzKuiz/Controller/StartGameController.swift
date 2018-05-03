//
//  StartQuizController.swift
//  EzKuiz
//
//  Created by Dávid Mohácsi on 2018. 04. 26..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit
import CoreData

class StartGameController: UITableViewController {
    
    let context = AppDelegate.viewContext
    var quizes: [Quiz]!
    var quiz: Quiz!
    @IBOutlet var gamesTableView: UITableView!
    let startQuizSegueID = "startQuizSegue"
    
    override func viewDidLoad() {

        self.processData()
        self.quizes = self.featchQuizes().sorted(by: { Int($0.id!)! < Int($1.id!)! })
    }
    
    fileprivate func processData() {
        
        let jsonStr = Util.getFileContentAsString(filename: "quizes", ext: "json")
        
        do {
        
            guard let data = jsonStr.data(using: .utf8) else { return }
            guard let rootArray = try JSONSerialization.jsonObject(with: data, options : []) as? [[String: Any]] else { return }
            
            for _quiz in rootArray {
                
                let quiz = Quiz(context: context)
                
                quiz.id = _quiz["id"] as? String
                quiz.name = _quiz["name"] as? String
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 2018-04-27T18:25:43
                quiz.date = dateformatter.date(from: _quiz["date"] as! String)
                
                quiz.language = _quiz["language"] as? String
                quiz.author = _quiz["author"] as? String
                
                for _question in (_quiz["questions"] as? [[String: Any]])! {
                    
                    let question = Question(context: context)
                    
                    question.order = Int64((_question["order"] as? String)!)!
                    question.text = _question["text"] as? String
                    
                    for _answer in (_question["answers"] as? [[String: Any]])! {
                        
                        let answer = Answer(context: context)
                        
                        answer.text = _answer["text"] as? String
                        answer.isRight = ((_answer["isRight"] as? String)?.toBool())!
                        
                        question.addToAnswers(answer)
                    }
                    
                    quiz.addToQuestions(question)
                }
            }
            
            do {
                try context.save()
                NSLog("Successfully saved into database.")
            } catch {
                NSLog("Error while saving: \(error.localizedDescription)")
            }
        } catch {
            fatalError("Cannot get game content: \(error)")
        }
    }
    
    fileprivate func featchQuizes() -> [Quiz] {
        
        let quizFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Quiz")
        var fetchResult: [Quiz]!
        
        do {
            fetchResult = try context.fetch(quizFetch) as! [Quiz]
            NSLog("Successfully fetched Game(s).")
            
        } catch {
            fatalError("Failed to fetch Game(s): \(error)")
        }
        
        return fetchResult
    }
    
    // Table functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = gamesTableView.dequeueReusableCell(withIdentifier: "gameCellTemplate") as! GameCell
        
        cell.nameLabel.text = self.quizes[indexPath.row].name
        cell.authorLabel.text = self.quizes[indexPath.row].author
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy.MM.dd. h:mm"
        cell.dateLabel.text = dateformatter.string(from: self.quizes[indexPath.row].date!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.quiz = self.quizes[indexPath.row]
        performSegue(withIdentifier: startQuizSegueID, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    // Segue funcs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == startQuizSegueID {
            
            if let quizView = segue.destination as? QuizViewController {
                quizView._quiz = self.quiz
            }
        }
    }
    
    @IBAction func unwindToVC1(segue: UIStoryboardSegue) {
        print("Unwinding to Start Game...")
    }
}
