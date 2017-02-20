//
//  StatsViewController.swift
//  Hangman
//
//  Created by Alex Erviti on 2/17/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import UIKit

// Extension by Sebastian - Stackoverflow
extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var avgGuessLabel: UILabel!
    @IBOutlet weak var bestGuessLabel: UILabel!
    
    
    @IBOutlet weak var modifierTextField: UITextField!
    @IBOutlet weak var modifierNumTextField: UITextField!
    @IBOutlet weak var statsTable: UITableView!
    var hangman: Hangman!;
    
    
    
    // MARK: - View Loading

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table delegate and datasource
        statsTable.delegate = self;
        statsTable.dataSource = self;
        
        // Load statistics labels
        let stats: Statistics = hangman.stats;
        scoreLabel.text = String(stats.totalScore());
        totalLabel.text = String(stats.totalGames());
        winsLabel.text = String(stats.wins());
        lossesLabel.text = String(stats.losses());
        ratioLabel.text = String(stats.winLossRatio().roundTo(places: 2));
        avgGuessLabel.text = String(stats.averageGuess().roundTo(places: 2));
        bestGuessLabel.text = String(stats.bestGuess());
        
        // Set up picker views for modifier and modifier num text fields
        let screenWidth = view.bounds.size.width;
        let modifierToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44));
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(modifierPickerPressed));
        modifierToolBar.setItems([space, doneButton], animated: false);
        
        let modifierPicker = UIPickerView(frame: CGRect(x: 0, y: modifierToolBar.frame.size.height, width: screenWidth, height: 200));
        modifierPicker.delegate = self;
        modifierPicker.dataSource = self;
        modifierPicker.showsSelectionIndicator = true;
        modifierTextField.inputView = modifierPicker;
        modifierTextField.inputAccessoryView = modifierToolBar;
        modifierToolBar.isUserInteractionEnabled = true;
        
        let modifierNumToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44));
        let doneButton2 = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(modifierNumPickerPressed));
        modifierNumToolBar.setItems([space, doneButton2], animated: false);
        
        let modifierNumPicker = UIPickerView(frame: CGRect(x: 0, y: modifierNumToolBar.frame.size.height, width: screenWidth, height: 200));
        modifierNumPicker.delegate = self;
        modifierNumPicker.dataSource = self;
        modifierNumPicker.showsSelectionIndicator = true;
        modifierNumTextField.inputView = modifierNumPicker;
        modifierNumTextField.inputAccessoryView = modifierNumToolBar;
        modifierNumToolBar.isUserInteractionEnabled = true;
        // Disable temporarily
        modifierNumTextField.isEnabled = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - UITableViewDataSource
    
    /* Sets sections to number of stat categories. */
    func numberOfSections(in tableView: UITableView) -> Int {
        switch modifierTextField.text! {
            case "Difficulty": return 10;
            case "Word Length": return 11;
            case "Guess Max": return 20;
            default: return 0;
        }
    }
    
    /* Sets the cell could to number of stats. */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    /* Sets the header for the stat category. */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let string: String;
        switch modifierTextField.text! {
            case "Difficulty":
                string = String(section + 1);
            case "Word Length":
                string = String(section + 2);
            case "Guess Max":
                string = String(section + 1);
            default:
                string = "N/A";
        }
        return modifierTextField.text! + ": " + string;
    }
    
    /* Function that modifies height of header section in the stats table. */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) { return 40; }
        return 30;
    }
    
    /* Function that modifies height of footer section in the stats table. */
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10;
    }
    
    /* Formats each cell based on the stat. */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "StatsTableViewCell";
        let cell = statsTable.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! StatsTableViewCell;
        let stat: StatLine;
        switch modifierTextField.text! {
            case "Difficulty":
                stat = hangman.stats.getStat(.difficulty, indexPath.section+1);
            case "Word Length":
                stat = hangman.stats.getStat(.wordLength, indexPath.section+2);
            default:
                stat = hangman.stats.getStat(.guessMax, indexPath.section+1);
        }
        
        cell.totalLabel.text = String(stat.total);
        cell.winsLabel.text = String(stat.wins);
        cell.lossesLabel.text = String(stat.losses);
        cell.ratioLabel.text = String(stat.winLossRatio.roundTo(places: 2));
        cell.avgGuessLabel.text = String(stat.averageGuess.roundTo(places: 2));
        cell.bestGuessLabel.text = String(stat.bestGuess);
        return cell;
    }
    
    
    
    // MARK: - UIPickerView DataSource/Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == modifierTextField.inputView) {
            return 3;
        }else if (pickerView == modifierNumTextField.inputView) {
            switch modifierTextField.text! {
                case "Difficulty": return 11;
                case "Word Length": return 13;
                case "Guess Max": return 21;
                default: break;
            }
        }
        return 0;
    }
    
    
    /* Assign the title for each itme in the picker view. */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == modifierTextField.inputView) {
            switch row {
                case 0: return "Difficulty";
                case 1: return "Word Length";
                case 2: return "Guess Max";
                default: break;
            }
        }else if (pickerView == modifierNumTextField.inputView) {
            switch row {
                case 0: return "All";
                default: return String(row);
            }
        }
        return "";
    }
    
    
    /* When an item is selected, change text of corresponding text view. */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == modifierTextField.inputView) {
            switch row {
                case 0: modifierTextField.text = "Difficulty";
                case 1: modifierTextField.text = "Word Length";
                case 2: modifierTextField.text = "Guess Max";
                default: break;
            }
            (modifierNumTextField.inputView as! UIPickerView).selectRow(0, inComponent: 0, animated: false);
        }else if (pickerView == modifierNumTextField.inputView) {
            switch row {
                case 0: modifierNumTextField.text = "All";
                default: modifierNumTextField.text = String(row);
            }
        }
    }
    
    
    /* Closes a modifier picker view when Done is tapped. */
    func modifierPickerPressed() {
        statsTable.reloadData();
        //statsTable.setNeedsDisplay();
        modifierTextField.resignFirstResponder();
    }
    
    
    /* Closes a modifier number picker view when Done is tapped. */
    func modifierNumPickerPressed() {
        statsTable.reloadData();
        //statsTable.setNeedsDisplay();
        modifierNumTextField.resignFirstResponder()
    }

}
