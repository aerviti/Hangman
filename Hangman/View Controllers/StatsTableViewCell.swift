//
//  StatsTableViewCell.swift
//  Hangman
//
//  Created by Alex Erviti on 2/18/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var avgGuessLabel: UILabel!
    @IBOutlet weak var bestGuessLabel: UILabel!
    
    
    // MARK: - View Loading

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
