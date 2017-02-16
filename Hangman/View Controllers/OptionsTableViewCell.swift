//
//  OptionsTableViewCell.swift
//  Hangman
//
//  Created by Alex Erviti on 2/15/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var optionsTitleLabel: UILabel!
    @IBOutlet weak var optionsCounter: UILabel!
    @IBOutlet weak var optionsStepper: UIStepper!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
