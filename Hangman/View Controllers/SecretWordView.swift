//
//  SecretWordView.swift
//  Hangman
//
//  Created by Alex Erviti on 2/16/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class SecretWordView: UIView {

    // MARK: - Properties
    
    var labelArray: [UILabel] = [UILabel]();
    var word: String?;
    
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        self.backgroundColor = UIColor.clear;
        for _ in 0..<12 {
            let label = UILabel();
            label.font = UIFont.systemFont(ofSize: 22);
            label.adjustsFontSizeToFitWidth = true;
            label.textAlignment = .center;
            label.text = "_";
            label.textColor = UIColor.black;
            labelArray.append(label);
            self.addSubview(label);
        }
        
    }
    
    
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        if (word != nil) {
            let length = CGFloat(word!.characters.count);
            let spacing: CGFloat = 10.0;
            let labelWidth = (self.frame.width - spacing*length) / length;
            for index in 0..<Int(length) {
                let label = labelArray[index];
                let x = spacing/2 + labelWidth*CGFloat(index) + spacing*CGFloat(index);
                label.frame = CGRect(x: x, y: 0, width: labelWidth, height: self.frame.height);
            }
        }
    }
    
    
    
    // MARK: - Functions
    
    func updateWord(_ array: [Character]) {
        for (index, char) in array.enumerated() {
            labelArray[index].text = String(char);
        }
    }
    
    func fillWord(_ array: [Character]) {
        for (index, char) in array.enumerated() {
            let letter = labelArray[index].text!;
            if (letter == "_") {
                labelArray[index].text = String(char);
                labelArray[index].textColor = UIColor.red;
            }
        }
    }

}
