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
    
    var total: Int {
        return wins + losses;
    }
    var wins: Int = 0;
    var losses: Int = 0;
    var winLossRatio: Double {
        if (losses == 0) { return Double(wins); }
        return Double(wins) / Double(losses);
    }
    var averageGuess: Double = 0.0;
    private var _bestGuess: Int = Int.max;
    var bestGuess: Int { // Mask for best guess, to deal with initial max value placeholder
        if _bestGuess > 20 { return 0; }
        return _bestGuess;
    }
    var bestScore: Int = 0;
    
    
    
    // MARK: - Initialization
    
    init(wins: Int, losses: Int, avgGuess: Double, bestGuess: Int, bestScore: Int) {
        self.wins = wins;
        self.losses = losses;
        self.averageGuess = avgGuess;
        self._bestGuess = bestGuess;
        self.bestScore = bestScore;
    }
    
}
