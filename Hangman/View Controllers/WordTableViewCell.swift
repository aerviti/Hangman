//
//  WordTableViewCell.swift
//  Hangman
//
//  Created by Alex Erviti on 2/17/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var wordTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
