//
//  AnswerCell.swift
//  EzKuiz
//
//  Created by Dávid Mohácsi on 2018. 04. 26..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit

class AnswerOption: UIButton {

    var isCorrect: Bool!
    var points: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
