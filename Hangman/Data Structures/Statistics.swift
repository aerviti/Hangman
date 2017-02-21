//
//  Statistics.swift
//  Hangman
//
//  Created by Alex Erviti on 2/14/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation

// Array Extension: repeating value initializer that creates new instances of repeating class
extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}

class Statistics: NSObject, NSCoding {
    
    // MARK: - Enum
    
    enum StatType {
        case difficulty;
        case wordLength;
        case guessMax;
    }
    
    
    // MARK: - Properties
    
    private var score: Int = 0;
    private var allStat: StatLine = StatLine();
    private var difficultyStats: [StatLine] = Array<StatLine>(count: 11, elementCreator: StatLine());
    private var wordLengthStats: [StatLine] = Array<StatLine>(count: 13, elementCreator: StatLine());
    private var guessMaxStats: [StatLine] = Array<StatLine>(count: 21, elementCreator: StatLine());
    
    
    
    // MARK: - Initialization
    
    override init() {
        super.init();
    }
    
    /* Initializer for NSCoding. */
    init(score: Int, allStat: StatLine, difStats: [StatLine], wlStats: [StatLine], gmStats: [StatLine]) {
        self.score = score;
        self.allStat = allStat;
        self.difficultyStats = difStats;
        self.wordLengthStats = wlStats;
        self.guessMaxStats = gmStats;
    }
    
    
    
    // MARK: - Functions
    
    /* Return total games played. */
    func totalGames() -> Int {
        return allStat.total;
    }
    
    /* Return total wins. */
    func wins() -> Int {
        return allStat.wins;
    }
    
    /* Return total losses. */
    func losses() -> Int {
        return allStat.losses;
    }
    
    /* Return win:loss ratio. */
    func winLossRatio() -> Double {
        return allStat.winLossRatio;
    }
    
    /* Return average guess. */
    func averageGuess() -> Double {
        return allStat.averageGuess;
    }
    
    /* Return best guess. */
    func bestGuess() -> Int {
        return allStat.bestGuess;
    }
    
    /* Returns score. */
    func totalScore() -> Int {
        return score;
    }
    
    /* Returns best score. */
    func bestScore() -> Int {
        return allStat.bestScore;
    }
    
    /* Function that stores the finished game in the appropriate stats. */
    func storeGame(_ game: Game) {
        let guessMax = game.guessMax;
        let wordLength = game.wordArray.count;
        let difficulty = game.difficulty;
        
        score += Statistics.getScore(game);
        allStat.addGame(game);
        difficultyStats[difficulty].addGame(game);
        wordLengthStats[wordLength].addGame(game);
        guessMaxStats[guessMax].addGame(game);
    }
    
    /* Function that returns a StatLine with the given stat type and stat value. */
    func getStat(_ type: StatType, _ num: Int) -> StatLine {
        switch type {
            case .difficulty:
                return difficultyStats[num];
            case .wordLength:
                return wordLengthStats[num];
            case .guessMax:
                return guessMaxStats[num];
        }
    }
    
    /* Function that deals with games that have not been finished. */
    func unfinishedGame(_ game: Game) {
        // No current purpose
    }
    
    /* Static function that derives a score from a finished game and its variables. */
    static func getScore(_ game: Game) -> Int {
        if game.winGame() {
            let difficulty = game.difficulty;
            let wordLength = game.wordArray.count;
            let guessMax = game.guessMax;
            let guesses = game.guessNum;
            var score = difficulty*wordLength * 200
            score = score / (guessMax*guesses);
            return score;
        }
        return 0;
    }
    
    
    
    // MARK: - Encoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: "score");
        aCoder.encode(allStat, forKey: "allStat");
        aCoder.encode(difficultyStats, forKey: "difficultyStats");
        aCoder.encode(wordLengthStats, forKey: "wordLengthStats");
        aCoder.encode(guessMaxStats, forKey: "guessMaxStats");
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeInteger(forKey: "score");
        let allStat = aDecoder.decodeObject(forKey: "allStat") as! StatLine;
        let difficultyStats = aDecoder.decodeObject(forKey: "difficultyStats") as! [StatLine];
        let wordLengthStats = aDecoder.decodeObject(forKey: "wordLengthStats") as! [StatLine];
        let guessMaxStats = aDecoder.decodeObject(forKey: "guessMaxStats") as! [StatLine];
        self.init(score: score, allStat: allStat, difStats: difficultyStats, wlStats: wordLengthStats, gmStats: guessMaxStats);
    }
}
