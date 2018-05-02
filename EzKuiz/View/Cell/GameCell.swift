//
//  QuestionCell.swift
//  EzKuiz
//
//  Created by SuIT Solutions on 2018. 04. 26..
//  Copyright © 2018. Suit Solutions. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
