//
//  StatLine.swift
//  Hangman
//
//  Created by Alex Erviti on 2/17/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation

class StatLine {
    
    // MARK: - Properties
    
    var name: String = "";
    var total: Int {
        return wins + losses;
    }
    var wins: Int = 0;
    var losses: Int = 0;
    var averageGuess: Int = 0;
    
    
    // MARK: - Functions
    
    /* Function that, given a game, adds whether it was a win or loss and updates the average guess property. */
    func addGame(_ game: Game) {
        if game.winGame() {
            wins += 1;
        }
        averageGuess = (total*averageGuess + game.guessNum) / total;
    }
    
}
