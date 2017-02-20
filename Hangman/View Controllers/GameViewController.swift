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
    
    // View Properties
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var guessesLeftLabel: UILabel!
    @IBOutlet weak var keyboardView: KeyboardView!
    @IBOutlet weak var secretWordView: SecretWordView!
    @IBOutlet weak var scoreTitle: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Gallows Properties
    @IBOutlet weak var head: UIImageView!
    @IBOutlet weak var body: UIImageView!
    @IBOutlet weak var leftArm: UIImageView!
    @IBOutlet weak var rightArm: UIImageView!
    @IBOutlet weak var leftLeg: UIImageView!
    @IBOutlet weak var rightLeg: UIImageView!
    @IBOutlet weak var frown: UIImageView!
    var partsArray: [UIImageView]!;
    
    // Variables
    var hangman: Hangman!;
    var twoPlayer: Bool = false;
    
    
    
    // MARK: - View Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up secret word view
        secretWordView.word = hangman.currentGame!.word;
        print(secretWordView.word!);
        secretWordView.setNeedsLayout();
        
        // Set up target keyboard buttons
        for button in keyboardView.buttons {
            button.addTarget(self, action: #selector(keyboardTapped(_:)), for: .touchUpInside);
        }
        keyboardView.wordButton.addTarget(self, action: #selector(wordButtonTapped(_:)), for: .touchUpInside);
        
        // Set up  guesses left label and hide body parts
        guessesLeftLabel.text = "Guesses Left: " + String(hangman.remainingGuesses());
        partsArray = [head,body,leftArm,rightArm,leftLeg,rightLeg];
        hideAllParts();
        
        // Temporarily hide score labels
        scoreTitle.isHidden = true;
        scoreLabel.isHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Game Functions
    
    /* Function that processes the given game outcome. Updates appropriate views based on the outcome. 
     * Disables keyboard and presents the appropriate message if the game is over. */
    func processOutcome(_ outcome: Game.GameOutcome) {
        // Update secret word, guess notification, and gallows
        secretWordView.updateWord(hangman.currentGame!.guessArray);
        guessesLeftLabel.text = "Guesses Left: " + String(hangman.remainingGuesses());
        updateGallows(hangman.remainingGuessesRatio());
        
        switch outcome {
            case .lossGuess:
                disableKeyboard();
                secretWordView.fillWord(hangman.currentGame!.wordArray);
                guessesLeftLabel.text = "You lose!";
                setScore(hangman.currentGame!);
                Hangman.saveHangman(hangman: hangman);
                break;
            
            case .winGuess:
                disableKeyboard();
                guessesLeftLabel.text = "You win!";
                setScore(hangman.currentGame!);
                Hangman.saveHangman(hangman: hangman);
                break;
            
            default:
                break;
        }
    }
    
    /* Function that disables all keyboard buttons from touch input. */
    private func disableKeyboard() {
        for button in keyboardView.buttons {
            button.isEnabled = false;
        }
        keyboardView.wordButton.isEnabled = false;
    }
    
    /* Function that unhides the score labels and sets the appropriate score. */
    private func setScore(_ game: Game) {
        scoreTitle.isHidden = false;
        scoreLabel.isHidden = false;
        scoreLabel.text = String(hangman.stats.getScore(game));
    }

    
    
    // MARK: - Button Actions
    
    /* Function handling a keyboard button tap. If tapped, passes a letter guess to the Hangman game. */
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
    
    var okButton: UIAlertAction!; // Stored for future enabling/disabling
    
    /* Function handling a guess word button tap. Presents an alert asking for a word to be guessed. */
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
    
    
    
    // MARK: - Gallows Functions
    
    /* Function that hides all parts of the hangman. */
    func hideAllParts() {
        for part in partsArray {
            part.isHidden = true;
        }
        frown.isHidden = true;
    }
    
    /* Function that reveals parts of the hangman based off of the given ratio. */
    func updateGallows(_ ratio: Double) {
        let adjustedRatio = ratio * 6.0;
        let lastIndex = Int(adjustedRatio);
        for index in 0..<Int(lastIndex) {
            partsArray[index].alpha = 1;
            partsArray[index].isHidden = false;
        }
        
        // Show portion of next part if remainder
        if (lastIndex < 6) {
            let remainder = adjustedRatio - Double(lastIndex);
            partsArray[lastIndex].isHidden = false;
            partsArray[lastIndex].alpha = CGFloat(remainder);
        }
        
        // Show frown if all parts shown
        if (ratio == 1) {
            frown.isHidden = false;
        }
    }

}
