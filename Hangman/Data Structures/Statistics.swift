//
//  Statistics.swift
//  Hangman
//
//  Created by Alex Erviti on 2/14/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation

class Statistics {
    
    // MARK: - Properties
    
    var gameTotal: Int = 0;
    var wins: Int = 0;
    var losses: Int = 0;
    var averageGuess: Int = 0;
    var difficultyStats: [StatLine] = Array<StatLine>(repeating: StatLine(), count: 11);
    var wordLengthStats: [StatLine] = Array<StatLine>(repeating: StatLine(), count: 12);
    var guessMaxStats: [StatLine] = Array<StatLine>(repeating: StatLine(), count: 20);
    
    // MARK: - Initialization
    
    
    
    // MARK: - Functions
    
    func winLossRatio() -> Double {
        return Double(wins) / Double(losses);
    }
    
    /* Function that stores the finished game in the appropriate stats. */
    func storeGame(_ game: Game) {
        let guessMax = game.guessMax;
        let wordLength = game.wordArray.count;
        let difficulty = game.difficulty;
    }
    
    /* Function that deals with games that have not been finished. */
    func unfinishedGame(_ game: Game) {
        // Unimplemented
    }
}
