//
//  Statistics.swift
//  Hangman
//
//  Created by Alex Erviti on 2/14/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Array Extension: repeating value initializer that creates new instances of repeating class
extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}

class Statistics: NSObject, NSCoding {
    
    // MARK: - Enum
    
    enum StatType: String {
        case difficulty = "difficulty";
        case wordLength = "wordLength";
        case guessMax = "guessMax";
    }
    
    
    // MARK: - Properties
    
    private var score: Int = 0;
    
    // Core Data Class that communicates with database
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    
    
    // MARK: - Initialization
    
    override init() {
        super.init();
    }
    
    /* Initializer for NSCoding. */
    init(score: Int) {
        self.score = score;
    }
    
    
    
    // MARK: - Functions
    
    /* Returns score. */
    func totalScore() -> Int {
        return score;
    }
    
    /* Function that stores the finished game in Core Data for future use. */
    func storeGame(_ game: Game) {
        // Core Data storage
        let guessMax = game.guessMax;
        let wordLength = game.wordArray.count;
        let difficulty = game.difficulty;
        let score = Statistics.getScore(game);
        let guessNum = game.guessNum;
        let win = game.winGame();
        
        let entity = NSEntityDescription.entity(forEntityName: "Result", in: managedContext)!
        let result = NSManagedObject(entity: entity, insertInto: managedContext);
        let keyedValues: [String:Any] = ["score": score, "difficulty": difficulty, "wordLength": wordLength, "guessMax": guessMax, "win": win, "guessNum": guessNum];
        result.setValuesForKeys(keyedValues);
        do { // Save Core Data
            try managedContext.save();
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)");
        }
    }
    
    /* Function that fetches data and returns a StatLine instance with stats across all games. */
    func getAllStat() -> StatLine {
        let wins = getWins();
        let losses = getLosses();
        let avgGuess = getAvgGuess();
        let bestGuess = getBestGuess();
        let bestScore = getBestScore();
        return StatLine(wins: wins, losses: losses, avgGuess: avgGuess, bestGuess: bestGuess, bestScore: bestScore);
    }
    
    /* Function that fetches data and returns a StatLine instance including games with the given stat type and stat value. */
    func getStat(_ type: StatType, _ num: Int) -> StatLine {
        let wins = getWins(type, num);
        let losses = getLosses(type, num);
        let avgGuess = getAvgGuess(type, num);
        let bestGuess = getBestGuess(type, num);
        let bestScore = getBestScore(type, num);
        return StatLine(wins: wins, losses: losses, avgGuess: avgGuess, bestGuess: bestGuess, bestScore: bestScore);
    }
    
    /* Function that deals with games that have not been finished. */
    func unfinishedGame(_ game: Game) {
        // No current purpose
    }
    
    
    
    // MARK: - Static Functions
    
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
    
    
    
    // MARK: - Core Data Functions
    
    /* Retrieves total wins. */
    private func getWins() -> Int {
        let array = getInstances(arguments: ["win": true as NSNumber])
        return array?.count ?? 0;
    }
    
    /* Retrieves total losses. */
    private func getLosses() -> Int {
        let array = getInstances(arguments: ["win": false as NSNumber])
        return array?.count ?? 0;
    }
    
    /* Retrieves average guess. */
    private func getAvgGuess() -> Double {
        if let array = getInstances(arguments: ["win": true as NSNumber]) {
            var total = 0;
            for obj in array {
                total += obj.value(forKey: "guessNum") as! Int;
            }
            if (array.count == 0) { return 0; } // Divide by 0 check
            return Double(total) / Double(array.count);
        }
        return 0;
    }
    
    /* Retrieves best guess. */
    private func getBestGuess() -> Int {
        var bestGuess = Int.max;
        if let array = getInstances(arguments: ["win": true as NSNumber]) {
            for obj in array {
                let guessNum = obj.value(forKey: "guessNum") as! Int;
                if (guessNum < bestGuess) {
                    bestGuess = guessNum;
                }
            }
        }
        return bestGuess;
    }
    
    /* Retrieves best score. */
    private func getBestScore() -> Int {
        var bestScore = 0;
        if let array = getInstances(arguments: ["win": true as NSNumber]) {
            for obj in array {
                let score = obj.value(forKey: "score") as! Int;
                if (score > bestScore) {
                    bestScore = score;
                }
            }
        }
        return bestScore;
    }
    
    /* Retrives total wins given a StatType argument and its value. */
    private func getWins(_ stat: StatType, _ val: Int) -> Int {
        let array = getInstances(arguments: [stat.rawValue: val as NSNumber, "win": true as NSNumber])
        return array?.count ?? 0;
    }
    
    /* Retrieves total losses given a StatType argument and its value. */
    private func getLosses(_ stat: StatType, _ val: Int) -> Int {
        let array = getInstances(arguments: [stat.rawValue: val as NSNumber, "win": false as NSNumber])
        return array?.count ?? 0;
    }
    
    /* Retrieves the average guess given a StatType argument and its value. */
    private func getAvgGuess(_ stat: StatType, _ val: Int) -> Double {
        if let array = getInstances(arguments: [stat.rawValue: val as NSNumber, "win": true as NSNumber]) {
            var total = 0;
            for obj in array {
                total += obj.value(forKey: "guessNum") as! Int;
            }
            if (array.count == 0) { return 0; } // Divide by 0 check
            return Double(total) / Double(array.count);
        }
        return 0;
    }
    
    /* Retrieves the best guess given a StatType argument and its value. */
    private func getBestGuess(_ stat: StatType, _ val: Int) -> Int {
        var bestGuess = Int.max;
        if let array = getInstances(arguments: [stat.rawValue: val as NSNumber, "win": true as NSNumber]) {
            for obj in array {
                let guessNum = obj.value(forKey: "guessNum") as! Int;
                if (guessNum < bestGuess) {
                    bestGuess = guessNum;
                }
            }
        }
        return bestGuess;
    }
    
    /* Retrieves the best score given a StatType argument and its value. */
    private func getBestScore(_ stat: StatType, _ val: Int) -> Int {
        var bestScore = 0;
        if let array = getInstances(arguments: [stat.rawValue: val as NSNumber, "win": true as NSNumber]) {
            for obj in array {
                let score = obj.value(forKey: "score") as! Int;
                if (score > bestScore) {
                    bestScore = score;
                }
            }
        }
        return bestScore;
    }
    
    /* Helper function that, given a set of arguments, returns an array of every game result matching that set of arguments. */
    private func getInstances(arguments: [String:CVarArg]) -> [NSManagedObject]? {
        var predicates = [NSPredicate]();
        for key in arguments.keys {
            let value = arguments[key]!;
            let string = key + " == %@"
            let newPred = NSPredicate(format: string, value);
            predicates.append(newPred);
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Result");
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates);
        do {
            return try managedContext.fetch(fetchRequest);
        }catch {
            print("Error drawing from Core Data.");
        }
        return nil;
    }
    
    
    
    // MARK: - Encoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: "score");
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeInteger(forKey: "score");
        self.init(score: score);
    }
}
