//
//  TitleViewController.swift
//  Hangman
//
//  Created by Alex Erviti on 2/13/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var onePlayerButton: UIButton!
    @IBOutlet weak var twoPlayerButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    var hangman: Hangman!;
    
    
    
    // MARK: - View Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Hangman instance
        hangman = Hangman();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Setup options view controller for a one player game
        if segue.identifier == "OneOptionsSegue" {
            let destination = segue.destination as! OptionsViewController;
            destination.hangman = hangman;
            destination.twoPlayer = false;
        }
        
        // Setup game view controller for a two player game
        if segue.identifier == "TwoOptionsSegue" {
            let destination = segue.destination as! OptionsViewController;
            destination.hangman = hangman;
            destination.twoPlayer = true;
        }
    }
    
    /* Function handling the return from a game or option view controller. */
    @IBAction func unwindToTitle(_ sender: UIStoryboardSegue) {
        // Register cancelled game
        hangman.clearGame();
    }

}

