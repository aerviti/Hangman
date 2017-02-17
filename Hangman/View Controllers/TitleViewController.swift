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
        if segue.identifier == "OptionsSegue" {
            let destination = segue.destination as! OptionsViewController;
            destination.hangman = hangman;
        }
        
        // Setup game view controller for a two player game
        if segue.identifier == "TwoPlayerSegue" {
            let destination = segue.destination as! GameViewController;
            destination.hangman = hangman;
            destination.twoPlayer = true;
            let word = sender as! String;
            hangman.startTwoPlayerGame(word);
        }
    }
    
    /* Function handling the return from a game or option view controller. */
    @IBAction func unwindToTitle(_ sender: UIStoryboardSegue) {
        // Register cancelled game
        hangman.clearGame();
    }
    
    
    var okButton: UIAlertAction!; // Stored for enabling/disabling
    
    /* Function handling a Two Player button tap. Presents an alert asking for a word to be used. */
    @IBAction func twoPlayerTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Pick a word to be guessed:", message: "Word must be between the length of 2 and 12, and contain only letters.", preferredStyle: .alert);
        alertController.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.checkWord(_:)), for: .editingChanged);
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        let okAction = UIAlertAction(title: "Play", style: .default) { (_) in
            let word = alertController.textFields![0].text;
            self.performSegue(withIdentifier: "TwoPlayerSegue", sender: word);
        }
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        okAction.isEnabled = false;
        self.okButton = okAction;
        self.present(alertController, animated: true, completion: nil);
    }
    
    /* Helper function that checks to see if the word given is valid for a game of hangman. */
    func checkWord(_ sender: UITextField) {
        let allowedCharacters = CharacterSet(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM");
        let word = sender.text!;
        if (word.characters.count >= 2 && word.characters.count <= 12 && word.rangeOfCharacter(from: allowedCharacters.inverted) == nil) {
            okButton.isEnabled = true;
        }else {
            okButton.isEnabled = false;
        }
    }


}

