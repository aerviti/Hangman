//
//  GameViewController.swift
//  Hangman
//
//  Created by Alex Erviti on 2/15/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var keyboardView: KeyboardView!
    @IBOutlet weak var secretWordView: SecretWordView!
    
    var hangman: Hangman!;
    
    
    
    // MARK: - View Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        
        secretWordView.word = hangman.currentGame!.word;
        print(secretWordView.word!);
        secretWordView.setNeedsLayout();
        
        for button in keyboardView.buttons {
            button.addTarget(self, action: #selector(keyboardTapped(_:)), for: .touchUpInside);
        }
        keyboardView.wordButton.addTarget(self, action: #selector(wordButtonTapped(_:)), for: .touchUpInside);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Game Functions
    
    func processOutcome(_ outcome: Game.GameOutcome) {
        // Update secret word
        secretWordView.updateWord(hangman.currentGame!.guessArray);
    }
    

    
    // MARK: - Button Actions
    
    func keyboardTapped(_ sender: KeyboardButton) {
        let character = sender.key;
        sender.isEnabled = false;
        sender.alpha = 0.3;
        sender.setTitleColor(UIColor.lightGray, for: .normal);
        do {
            let outcome = try hangman.guessLetter(character!);
            processOutcome(outcome);
        }catch {
            // No current game
        }
    }
    
    var okButton: UIAlertAction!;
    
    func wordButtonTapped(_ sender: KeyboardButton) {
        let alertController = UIAlertController(title: "Write in your guess:", message: "Word must be between the length of 2 and 12, and contain only letters.", preferredStyle: .alert);
        alertController.addTextField { (textField) in
            textField.addTarget(self, action: #selector(self.checkWord(_:)), for: .editingChanged);
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        let okAction = UIAlertAction(title: "Guess", style: .default) { (_) in
            do {
                let word = alertController.textFields![0].text!;
                let outcome = try self.hangman.guessWord(word);
                self.processOutcome(outcome);
            }catch {
                // No current game
            }
        }
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        okAction.isEnabled = false;
        self.okButton = okAction;
        self.present(alertController, animated: true, completion: nil);
    }
    
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
