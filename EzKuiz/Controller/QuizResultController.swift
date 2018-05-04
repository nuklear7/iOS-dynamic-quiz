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
    var resultCurrent: NSDecimalNumber!
    var resultMax: NSDecimalNumber!
    var scoring: Set<NSManagedObject>!
    
    override func viewDidLoad() {
        
        scoreLabel.text = "\(resultCurrent!)/\(resultMax!)"
        navigationItem.hidesBackButton = true
        
        self.processScoring()
    }
    
    private func processScoring() {
        
        let resultPercent = resultCurrent.dividing(by: resultMax).multiplying(by: 100)
        
        for score in scoring {
    
            let score = score as! Scoring
            
            if NSDecimalNumber(string: String(describing: resultPercent)).compare(score.percent!).rawValue == -1 ||
                NSDecimalNumber(string: String(describing: resultPercent)).compare(score.percent!).rawValue == 0 {
                
                self.resultLabel.text = score.text!
                break
            }
        }
    }
    
    @IBAction func onBtnBackToStartGame(_ sender: Any) {
        performSegue(withIdentifier: unwindStartGameSegueID, sender: self)
    }
}
