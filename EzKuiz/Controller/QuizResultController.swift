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
    var resultCurrent: Int!
    var resultMax: Int!
    var scoring: Set<NSManagedObject>!
    
    override func viewDidLoad() {
        
        resultLabel.text = "\(resultCurrent!)/\(resultMax!)"
        navigationItem.hidesBackButton = true
        
        for score in scoring {
            
            var score = score as! Scoring
            
            print(score.percent)
        }
    }
    
    @IBAction func onBtnBackToStartGame(_ sender: Any) {
        performSegue(withIdentifier: unwindStartGameSegueID, sender: self)
    }
}
