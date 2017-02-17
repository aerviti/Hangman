//
//  Game.swift
//  Hangman
//
//  Created by Alex Erviti on 2/13/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation

class Game {
    
    // MARK: - Enumerations
    
    // Enumeration for the six potential outcomes from a guess
    enum GameOutcome {
        case gameOver;
        case alreadyGuessed;
        case incorrectGuess;
        case correctGuess;
        case winGuess;
        case lossGuess;
    }
    
    
    
    // MARK: - Properties
    
    var word: String;
    var wordArray: Array<Character> = Array<Character>();
    var guessArray: Array<Character> = Array<Character>();
    var guessMax: Int;
    var incorrectGuessNum: Int = 0;
    var guessNum: Int = 0;
    var revealedLetters: Int = 0;
    var guessedLetters: Set<Character> = Set<Character>();
    var difficulty: Int; // Equal to 0 if two player game
    var gameOver: Bool = false;
    
    
    
    // MARK: - Initialization
    
    init(word: String, guessMax: Int, difficulty: Int) {
        let capWord = word.uppercased();
        self.word = capWord;
        self.guessMax = guessMax;
        self.difficulty = difficulty;
        
        //Set up arrays for the given word
        for letter in capWord.characters {
            wordArray.append(letter);
            guessArray.append("_");
        }
    }
    
    
    
    // MARK: - Functions
    
    /* Returns true if the game has ended as a loss. Otherwise, returns false. */
    func winGame() -> Bool {
        if (revealedLetters == wordArray.count) {
            return true;
        }
        return false;
    }
    
    /* Returns true if the game has neded as a loss. Otherwise, returns false. */
    func lossGame() -> Bool {
        if (incorrectGuessNum == guessMax) {
            return true;
        }
        return false;
    }
    
    /* Function used to guess a letter in the secret word. Given a Character, will update guess stats
     * and the current status of the guess array, along with returning one of six potential outcomes
     * from the enum GameOutcome. */
    func guessLetter(_ guess: Character) -> GameOutcome {
        // Game already over
        if gameOver { return .gameOver; }
        
        // Already guessed
        if guessedLetters.contains(guess) { return .alreadyGuessed; }
        
        // Update guess stats, run through word with guess, and check if incorrect
        guessNum += 1;
        guessedLetters.insert(guess);
        if !guessCheck(guess) {
            incorrectGuessNum += 1;
            if lossGame() {
                gameOver = true;
                return .lossGuess
            }
            return .incorrectGuess;
        }
        
        // Win check
        if winGame() {
            gameOver = true;
            return .winGuess;
        }
        
        // Otherwise, correct guess
        return .correctGuess;
    }
    
    
    /* Runs through the word array with the provided guess and updates the guess array. If the guess is 
     * contained in the word, return true. Otherwise return false. */
    private func guessCheck(_ guess: Character) -> Bool {
        var correctGuess = false;
        for (index, letter) in wordArray.enumerated() {
            if (letter == guess) {
                correctGuess = true;
                guessArray[index] = letter;
                revealedLetters += 1;
            }
        }
        return correctGuess;
    }
    
    
    /* Function used to guess the secret word. Given a String, checks to see if it matches the secret
     * word, updating guess stats and returning one of six potential outcomes from the the enum 
     * GameOutcome. */
    func guessWord(_ g: String) -> GameOutcome {
        // Game already over
        if gameOver { return .gameOver; }
        
        // Uppercase entire guess
        let guess = g.uppercased();
        
        // Check if guess is correct
        guessNum += 1;
        if (guess == word) {
            revealAll();
            gameOver = true;
            return .winGuess;
        }
        
        // Check if a losing guess, otherwise incorrect guess
        incorrectGuessNum += 1;
        if lossGame() {
            gameOver = true;
            return .lossGuess;
        }
        return .incorrectGuess;
    }
    
    /* Function that reveals all words in the guess array. */
    private func revealAll() {
        guessArray = wordArray;
    }
    
    /* Function that returns a string version of the GuessArray, where underscores represent parts of
     * the word that have not yet been guessed. */
    func getCurrentGuess() -> String {
        var string = "";
        for char in guessArray {
            string += String(char);
        }
        return string;
    }
    
    
    
    
}
