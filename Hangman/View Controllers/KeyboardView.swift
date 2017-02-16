//
//  KeyboardView.swift
//  Hangman
//
//  Created by Alex Erviti on 2/16/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class KeyboardView: UIView {

    // MARK: - Properties
    
    var buttons: [KeyboardButton] = [KeyboardButton]();
    var wordButton: KeyboardButton!;
    let characters: [Character] = ["Q","W","E","R","T","Y","U","I","O","P",
                                   "A","S","D","F","G","H","J","K","L",
                                   "Z","X","C","V","B","N","M"];
    
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        self.backgroundColor = UIColor.clear;
        for char in characters {
            let newButton = KeyboardButton();
            newButton.setTitle(String(char), for: UIControlState.normal);
            newButton.setTitleColor(UIColor.lightGray, for: .highlighted);
            newButton.setTitleColor(UIColor.black, for: .normal);
            newButton.backgroundColor = UIColor.groupTableViewBackground;
            newButton.isEnabled = true;
            newButton.key = char;
            buttons.append(newButton);
            self.addSubview(newButton);
        }
        wordButton = KeyboardButton();
        wordButton.setTitle("Word", for: .normal);
        wordButton.setTitleColor(UIColor.lightGray, for: .highlighted);
        wordButton.setTitleColor(UIColor.black, for: .normal);
        wordButton.backgroundColor = UIColor.groupTableViewBackground;
        wordButton.isEnabled = true;
        wordButton.key = "!";
        self.addSubview(wordButton);
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.clear;
        for char in characters {
            let newButton = KeyboardButton();
            newButton.setTitle(String(char), for: UIControlState.normal);
            newButton.setTitleColor(UIColor.lightGray, for: .highlighted);
            newButton.setTitleColor(UIColor.black, for: .normal);
            newButton.backgroundColor = UIColor.groupTableViewBackground;
            newButton.isEnabled = true;
            newButton.key = char;
            buttons.append(newButton);
            self.addSubview(newButton);
        }
        wordButton = KeyboardButton();
        wordButton.setTitle("Word", for: .normal);
        wordButton.setTitleColor(UIColor.lightGray, for: .highlighted);
        wordButton.setTitleColor(UIColor.black, for: .normal);
        wordButton.backgroundColor = UIColor.groupTableViewBackground;
        wordButton.isEnabled = true;
        wordButton.key = "!";
        self.addSubview(wordButton);
    }
    
    
    override func draw(_ rect: CGRect) {
        let width = self.frame.width;
        
        let rowSpacing: CGFloat = 10.0;
        let spacing: CGFloat = 2.0;
        let buttonWidth = (width-spacing*10) / 10;
        let buttonHeight = buttonWidth * 1.5;

        // First row
        for index in 0..<10 {
            let button = buttons[index];
            let x = spacing + buttonWidth*CGFloat(index) + spacing*CGFloat(index);
            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: buttonHeight);
        }
        
        // Second row
        for index in 10..<19 {
            let button = buttons[index];
            let adjustedIndex = index - 10;
            let extraSpace = buttonWidth/2 + spacing;
            let x = extraSpace + buttonWidth*CGFloat(adjustedIndex) + spacing*CGFloat(adjustedIndex);
            button.frame = CGRect(x: x, y: buttonHeight+rowSpacing, width: buttonWidth, height: buttonHeight);
        }
        
        // Third row
        for index in 19..<26 {
            let button = buttons[index];
            let adjustedIndex = index - 19;
            let extraSpace = buttonWidth/2 + spacing*1.5;
            let x = extraSpace + buttonWidth*CGFloat(adjustedIndex) + spacing*CGFloat(adjustedIndex);
            button.frame = CGRect(x: x, y: buttonHeight*2+rowSpacing*2, width: buttonWidth, height: buttonHeight);
        }
        
        // Word button in third row
        let extraSpace = buttonWidth/2 + spacing*1.5;
        let x = extraSpace + buttonWidth*CGFloat(7) + spacing*CGFloat(7);
        wordButton.frame = CGRect(x: x, y: buttonHeight*2+rowSpacing*2, width: buttonWidth*2, height: buttonHeight);
    }

}
