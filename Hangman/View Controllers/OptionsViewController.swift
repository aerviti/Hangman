//
//  OptionsViewController.swift
//  Hangman
//
//  Created by Alex Erviti on 2/15/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var hangman: Hangman!;
    
    
    
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
            do {
                try hangman.startOnePlayerGame();
            }catch {
                // Word get error
            }
            // Wait for word to be selected and for game to start
            UIApplication.shared.beginIgnoringInteractionEvents();
            while (!hangman.hasGame()) { }
            UIApplication.shared.endIgnoringInteractionEvents();
        }
    }
    
    /* Function handling the return from a game or option view controller. */
    @IBAction func unwindToOptions(_ sender: UIStoryboardSegue) {
        // Register cancelled game
        hangman.clearGame();
    }
    
    //MARK: - UITableViewDataSource
    
    /* Sets the one section needed for the table view. */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /* Sets the count of cells to the number of table plans. */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    /* Formats each cell based on the option. */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "OptionsTableViewCell";
        let cell = optionsTable.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OptionsTableViewCell;
        
        switch indexPath.row {
        case 0: //Difficulty
            cell.optionsTitleLabel.text = "Difficulty";
            cell.optionsCounter.text = String(hangman.difficulty);
            difficultyLabel = cell.optionsCounter;
            difficultyStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(difficultyChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 10;
            cell.optionsStepper.minimumValue = 1;
            cell.optionsStepper.value = Double(hangman.difficulty);
            break;
            
        case 1: //Min Word Length
            cell.optionsTitleLabel.text = "Minimum Word Length";
            cell.optionsCounter.text = String(hangman.wordLengthMin);
            minLengthLabel = cell.optionsCounter;
            minLengthStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(minLengthChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 12;
            cell.optionsStepper.minimumValue = 2;
            cell.optionsStepper.value = Double(hangman.wordLengthMin);
            break;
            
        case 2: //Max Word Length
            cell.optionsTitleLabel.text = "Maximum Word Length";
            cell.optionsCounter.text = String(hangman.wordLengthMax);
            maxLengthLabel = cell.optionsCounter;
            maxLengthStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(maxLengthChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 12;
            cell.optionsStepper.minimumValue = 2;
            cell.optionsStepper.value = Double(hangman.wordLengthMax);
            break;
            
        case 3: //Guess limit
            cell.optionsTitleLabel.text = "Guess Limit";
            cell.optionsCounter.text = String(hangman.guessMax);
            guessMaxLabel = cell.optionsCounter;
            guessMaxStepper = cell.optionsStepper;
            cell.optionsStepper.addTarget(self, action: #selector(guessMaxChanged(_:)), for: .allTouchEvents);
            cell.optionsStepper.maximumValue = 20;
            cell.optionsStepper.minimumValue = 1;
            cell.optionsStepper.value = Double(hangman.guessMax);
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

}
