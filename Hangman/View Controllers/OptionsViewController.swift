//
//  OptionsViewController.swift
//  Hangman
//
//  Created by Alex Erviti on 2/15/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var optionsTable: UITableView!
    var difficultyLabel: UILabel!;
    var difficultyStepper: UIStepper!;
    var minLengthLabel: UILabel!;
    var minLengthStepper: UIStepper!;
    var maxLengthLabel: UILabel!;
    var maxLengthStepper: UIStepper!;
    var guessMaxLabel: UILabel!;
    var guessMaxStepper: UIStepper!;
    var wordTextField: UITextField!;
    
    var hangman: Hangman!;
    var twoPlayer: Bool!;
    
    
    
    // MARK: - View Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set table delegate and data source
        optionsTable.delegate = self;
        optionsTable.dataSource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Setup game view controller for a one player game
        if segue.identifier == "OnePlayerSegue" {
            let destination = segue.destination as! GameViewController;
            destination.hangman = hangman;
        }
        
        // Setup game view controller for a two player game
        if segue.identifier == "TwoPlayerSegue" {
            let destination = segue.destination as! GameViewController;
            let word = wordTextField.text!;
            hangman.startTwoPlayerGame(word);
            destination.hangman = hangman;
        }
        Hangman.saveHangman(hangman: hangman);
    }
    
    /* Function called when Play is pressed. Handles the start game and makes sure there are no errors 
     * before calling the segue. */
    @IBAction func playPressed(_ sender: UIButton) {
        // Perform two player segue, if two player
        if twoPlayer! {
            performSegue(withIdentifier: "TwoPlayerSegue", sender: self);
            return;
        }
        
        // Otherwise, set up one player game
        hangman.startOnePlayerGame();
        
        // Wait for response from URL session
        while (hangman.urlError == .waiting) { }
        // Check if there is an error in obtaining a word with the given parameters
        if (hangman.urlError == .noWord) {
            let noWordAlert = UIAlertController(title: "No Word Found", message: "The current set of options did not produce a word. Try changing difficulty or word length and try again.", preferredStyle: .alert);
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            noWordAlert.addAction(okButton);
            present(noWordAlert, animated: true, completion: nil);
            return;
            
        // Check if there is an error in reaching the dictionary server
        } else if (hangman.urlError == .noResponse) {
            let noResponseAlert = UIAlertController(title: "Cannot Reach Dictionary", message: "Cannot reach dictionary server. Make sure you are connected to the internet.", preferredStyle: .alert);
            let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            noResponseAlert.addAction(okButton);
            present(noResponseAlert, animated: true, completion: nil);
            return;
        }
        
        performSegue(withIdentifier: "OnePlayerSegue", sender: self);
    }
    
    /* Function handling the return from a game or option view controller. */
    @IBAction func unwindToOptions(_ sender: UIStoryboardSegue) {
        if !hangman.isGameOver() {
            hangman.stats.unfinishedGame(hangman.currentGame!);
        }
        hangman.clearGame();
    }
    
    
    
    //MARK: - UITableViewDataSource
    
    /* Sets the sections needed for the table view. */
    func numberOfSections(in tableView: UITableView) -> Int {
        if twoPlayer! {
            return 2;
        }
        return 1
    }
    
    /* Sets the count of cells to the number of options needed. */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if twoPlayer! {
            return 1;
        }
        return 4;
    }
    
    /* Sets the footer for the secret word section for two player option views. */
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 1) {
            return "Word must be between the length of 2 and 12, and contain only letters.";
        }
        return nil;
    }
    
    /* Formats each cell based on the option. */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If two sections, second section is word cell
        if (indexPath.section == 1) {
            let identifier = "WordTableViewCell";
            let cell = optionsTable.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WordTableViewCell;
            wordTextField = cell.wordTextField;
            cell.wordTextField.delegate = self;
            cell.wordTextField.addTarget(self, action: #selector(tableNameChanged(_:)), for: .editingChanged);
            playButton.isEnabled = false;
            playButton.alpha = 0.3;
            return cell;
        }
        
        // Otherwise, option cells
        let identifier = "OptionsTableViewCell";
        let cell = optionsTable.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OptionsTableViewCell;
        
        switch indexPath.row {
        case 0: //Guess limit
            cell.optionsTitleLabel.text = "Guess Limit";
            cell.optionsCounter.text = String(hangman.guessMax);
            guessMaxLabel = cell.optionsCounter;
            guessMaxStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(guessMaxChanged(_:)), for: .touchUpInside);
            cell.optionsStepper.maximumValue = 20;
            cell.optionsStepper.minimumValue = 1;
            cell.optionsStepper.value = Double(hangman.guessMax);
            break;
        case 1: //Difficulty
            cell.optionsTitleLabel.text = "Difficulty";
            cell.optionsCounter.text = String(hangman.difficulty);
            difficultyLabel = cell.optionsCounter;
            difficultyStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(difficultyChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 10;
            cell.optionsStepper.minimumValue = 1;
            cell.optionsStepper.value = Double(hangman.difficulty);
            break;
            
        case 2: //Min Word Length
            cell.optionsTitleLabel.text = "Minimum Word Length";
            cell.optionsCounter.text = String(hangman.wordLengthMin);
            minLengthLabel = cell.optionsCounter;
            minLengthStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(minLengthChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 12;
            cell.optionsStepper.minimumValue = 2;
            cell.optionsStepper.value = Double(hangman.wordLengthMin);
            break;
            
        case 3: //Max Word Length
            cell.optionsTitleLabel.text = "Maximum Word Length";
            cell.optionsCounter.text = String(hangman.wordLengthMax);
            maxLengthLabel = cell.optionsCounter;
            maxLengthStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(maxLengthChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 12;
            cell.optionsStepper.minimumValue = 2;
            cell.optionsStepper.value = Double(hangman.wordLengthMax);
            break;
            
        default:
            break;
        }
        return cell;
    }
    
    
    
    // MARK: - Button Actions
    
    /* Action function triggered when the difficulty stepper is tapped. Changes difficulty to the new 
     * value. */
    func difficultyChanged(_ sender: UIStepper) {
        let newVal = Int(sender.value);
        difficultyLabel.text = String(newVal);
        hangman.difficulty = newVal;
    }
    
    
    /* Action function triggered when the min length stepper is tapped. Changes word length minimum to
     * the new value. */
    func minLengthChanged(_ sender: UIStepper) {
        let newVal = Int(sender.value);
        minLengthLabel.text = String(newVal);
        hangman.wordLengthMin = newVal;
        
        // Change maximum word length if minimum word length exceeds it
        if (newVal > hangman.wordLengthMax) {
            maxLengthLabel.text = String(newVal);
            maxLengthStepper.value = Double(newVal);
            hangman.wordLengthMax = newVal;
        }
    }
    
    
    /* Action function triggered when the max length stepper is tapped. Changes word length maximum to 
     * the new value. */
    func maxLengthChanged(_ sender: UIStepper) {
        let newVal = Int(sender.value);
        maxLengthLabel.text = String(newVal);
        hangman.wordLengthMax = newVal;
        
        // Change mimum word length if maximum word length is lower.
        if (newVal < hangman.wordLengthMin) {
            minLengthLabel.text = String(newVal);
            minLengthStepper.value = Double(newVal);
            hangman.wordLengthMin = newVal;
        }
    }
    
    
    /* Action function triggered when the guess max stepper is tapped. Changes guess limit to the new value. */
    func guessMaxChanged(_ sender: UIStepper) {
        let newVal = Int(sender.value);
        guessMaxLabel.text = String(newVal);
        hangman.guessMax = newVal;
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    /* Helper function that checks to see if the word given is valid for a game of hangman. */
    func checkWord(_ sender: UITextField) {
        let allowedCharacters = CharacterSet(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM");
        let word = sender.text!;
        if (word.characters.count >= 2 && word.characters.count <= 12 && word.rangeOfCharacter(from: allowedCharacters.inverted) == nil) {
            playButton.isEnabled = true;
            playButton.alpha = 1;
        }else {
            playButton.isEnabled = false;
            playButton.alpha = 0.3;
        }
    }
    
    
    //Hides the keyboard if return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    
    //Enables or disables the save button depending on the state of the name text field when editing is finished
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkWord(textField);
    }
    
    
    //Enables or disables save button depending on the state of the name text field while editing is occurring
    func tableNameChanged(_ sender: UITextField) {
        checkWord(sender);
    }

}
