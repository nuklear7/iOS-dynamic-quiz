//
//  QuizResultController.swift
//  EzKuiz
//
//  Created by SuIT Solutions on 2018. 04. 27..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit
import Foundation

class QuizResultController: UIViewController {
    
    let unwindStartGameSegueID = "unwindToStartGameSegue"
    
    @IBOutlet var resultLabel: UILabel!
    var result: String!
    
    override func viewDidLoad() {
        resultLabel.text = result
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func onBtnBackToStartGame(_ sender: Any) {
        performSegue(withIdentifier: unwindStartGameSegueID, sender: self)
    }
}
