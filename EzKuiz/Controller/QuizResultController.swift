//
//  QuizResultController.swift
//  EzKuiz
//
//  Created by SuIT Solutions on 2018. 04. 27..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class QuizResultController: UIViewController {
    
    let unwindStartGameSegueID = "unwindToStartGameSegue"
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var questionType: String?
    var resultCurrent: Double!
    var resultMax: Double!
    var scores: Set<NSManagedObject>!
    var sortedScores: [NSManagedObject]!
    var finalScore: Double?
    
    var numOfQuestions: Int?
    
    override func viewDidLoad() {
        
        self.sortedScores = scores.sorted(by: {
            ($0 as! Scoring).percent < ($1 as! Scoring).percent
        })
        scoreLabel.text = "\(Int(resultCurrent!))/\(Int(resultMax!))"
        navigationItem.hidesBackButton = true
        
        self.processScoring()
    }
    
    private func processScoring() {
        
        var resultPercent = 0.0
        
        if QuizTypes.scoring.rawValue == self.questionType {
            
            resultPercent = self.finalScore! / Double(self.numOfQuestions!)
        } else if QuizTypes.percent.rawValue == self.questionType {
            
            resultPercent = resultCurrent/resultMax*100
        }
        
        print("resultPercent: \(resultPercent)")
        
        for score in self.sortedScores {
    
            let score = score as! Scoring
            
            if resultPercent >= score.percent {
                
                self.resultLabel.text = score.text!
            } else {
                break
            }
        }
    }
    
    @IBAction func onBtnBackToStartGame(_ sender: Any) {
        performSegue(withIdentifier: unwindStartGameSegueID, sender: self)
    }
}
