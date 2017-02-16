//
//  Hangman.swift
//  Hangman
//
//  Created by Alex Erviti on 2/13/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation

//
// Class used to
//
//

class Hangman : NSObject, NSCoding {
    
    // MARK: - Enumerations
    
    enum HangmanError : Error {
        case noCurrentGame;
        case invalidDictionaryURL;
    }
    
    
    
    // MARK: - Properties
    
    let dictionaryURL = "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words"
    
    var guessMax: Int;
    var difficulty: Int;
    var wordLengthMin: Int;
    var wordLengthMax: Int;
    var stats: Statistics;
    var currentGame: Game?;
    
    
    
    // MARK: - Initialization
    
    override init() {
        guessMax = 6;
        difficulty = 1;
        wordLengthMin = 2;
        wordLengthMax = 12;
        stats = Statistics();
        currentGame = nil;
    }
    
    init(guessMax: Int, difficulty: Int, wordLengthMin: Int, wordLengthMax: Int, stats: Statistics) {
        self.guessMax = guessMax;
        self.difficulty = difficulty;
        self.wordLengthMin = wordLengthMin;
        self.wordLengthMax = wordLengthMax;
        self.stats = stats;
        currentGame = nil;
    }
    
    
    
    // MARK: - Functions
    
    /* Returns true if the current game is over, or false if it is not or there is no current game. */
    func isGameOver() -> Bool {
        if let game = currentGame {
            return game.gameOver;
        }
        return false;
    }
    
    /* Returns true if there is a current game, or false if there is not. */
    func hasGame() -> Bool {
        return currentGame != nil;
    }
    
    /* Function that clears the current game. */
    func clearGame() {
        currentGame = nil;
    }
    
    
    /* Starts a game using a random word from the word dictionary API, filtered by the current object's 
     * options. Makes an asynchronous call and requires time for the current game to register. */
    func startOnePlayerGame() throws {
        // Create dictionary URL based off of current options
        let dif = "?difficulty=" + String(difficulty);
        let min = "&minLength=" + String(wordLengthMin);
        let max = "&maxLength=" + String(wordLengthMax + 1);
        guard let url = URL(string: dictionaryURL + dif + min + max) else {
            throw HangmanError.invalidDictionaryURL;
        }
        // Create session and pull random word from dictionary
        let session = URLSession.shared;
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            // Break and print if error occurs
            if (error != nil) {
                print("Error retrieving word dictionary.");
                print(error!);
                return;
            }
            
            // Split words into an array and access a random word in that array, passing it to start game
            let words = String(data: data!, encoding: .utf8);
            let wordArray = words!.components(separatedBy: CharacterSet.newlines);
            let index = Int(arc4random_uniform(UInt32(wordArray.count)));
            self.startGame(wordArray[index]);
        })
        task.resume();
    }
    
    
    /* Starts a game with the given word. */
    func startTwoPlayerGame(_ string: String) {
        startGame(string);
    }
    
    
    /* Helper function that creates the current game with the given word and the max number of guesses 
     * allowed option. */
    private func startGame(_ string: String) {
        if (currentGame != nil) {
            //register game stats as cancelled game???
        }
        currentGame = Game(word: string, guessMax: guessMax);
    }
    
    
    /* Submits letter guess to the current game. Returns a Game.GameOutcome option based on the outcome 
     * of the guess. If no current game is set, throws an error. */
    func guessLetter(_ guess: Character) throws -> Game.GameOutcome {
        if let outcome = currentGame?.guessLetter(guess) {
            registerOutcome(outcome);
            return outcome;
        }
        throw HangmanError.noCurrentGame;
    }
    
    
    /* Submits a word guess to the current game. Returns a Game.GameOutcome option based on the outcome 
     * of the guess. If no current game is set, throws an error. */
    func guessWord(_ guess: String) throws -> Game.GameOutcome {
        if let outcome = currentGame?.guessWord(guess) {
            registerOutcome(outcome);
            return outcome;
        }
        throw HangmanError.noCurrentGame;
    }
    
    /* Helper function that adds the game results to the statistics if the game has ended. */
    private func registerOutcome(_ outcome: Game.GameOutcome) {
        if (outcome == .winGuess || outcome == .lossGuess) {
            //Register game stats
        }
    }
    
    
    
    // MARK: - Encoding
    
    //Archiving Paths
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!;
    static var ArchiveURL = DocumentsDirectory.appendingPathComponent("Hangman");
    
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(guessMax, forKey: "guessMax");
        aCoder.encode(difficulty, forKey: "difficulty");
        aCoder.encode(wordLengthMin, forKey: "wordLengthMin");
        aCoder.encode(wordLengthMax, forKey: "wordLengthMax");
        aCoder.encode(stats, forKey: "stats");
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let guessMax = aDecoder.decodeInteger(forKey: "guessMax");
        let difficulty = aDecoder.decodeInteger(forKey: "difficulty");
        let wordLengthMin = aDecoder.decodeInteger(forKey: "wordLengthMin");
        let wordLengthMax = aDecoder.decodeInteger(forKey: "wordLengthMax");
        let stats = aDecoder.decodeObject(forKey: "stats") as! Statistics;
        self.init(guessMax: guessMax, difficulty: difficulty, wordLengthMin: wordLengthMin, wordLengthMax: wordLengthMax, stats: stats);
    }
    
}
