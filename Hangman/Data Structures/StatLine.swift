//
//  StatLine.swift
//  Hangman
//
//  Created by Alex Erviti on 2/17/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation

class StatLine: NSObject, NSCoding {
    
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
    
    override init() {
        super.init();
    }
    
    init(wins: Int, losses: Int, avgGuess: Double, bestGuess: Int, bestScore: Int) {
        self.wins = wins;
        self.losses = losses;
        self.averageGuess = avgGuess;
        self._bestGuess = bestGuess;
        self.bestScore = bestScore;
    }
    
    
    // MARK: - Functions
    
    /* Function that, given a game, adds whether it was a win or loss and updates the guess and score properties. */
    func addGame(_ game: Game) {
        if game.winGame() {
            wins += 1;
            averageGuess = (Double(total-1)*averageGuess + Double(game.guessNum)) / Double(total);
            if (game.guessNum < _bestGuess) {
                _bestGuess = game.guessNum;
            }
            let score = Statistics.getScore(game);
            if (score > bestScore) {
                bestScore = score;
            }
        }else {
            losses += 1;
        }
    }
    
    
    
    // MARK: - Encoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(wins, forKey: "wins");
        aCoder.encode(losses, forKey: "losses");
        aCoder.encode(averageGuess, forKey: "averageGuess");
        aCoder.encode(_bestGuess, forKey: "bestGuess");
        aCoder.encode(bestScore, forKey: "bestScore");
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let wins = aDecoder.decodeInteger(forKey: "wins");
        let losses = aDecoder.decodeInteger(forKey: "losses");
        let averageGuess = aDecoder.decodeDouble(forKey: "averageGuess");
        let bestGuess = aDecoder.decodeInteger(forKey: "bestGuess");
        let bestScore = aDecoder.decodeInteger(forKey: "bestScore");
        self.init(wins: wins, losses: losses, avgGuess: averageGuess, bestGuess: bestGuess, bestScore: bestScore);
    }
    
}
