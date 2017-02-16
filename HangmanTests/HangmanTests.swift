//
//  HangmanTests.swift
//  Hangman
//
//  Created by Alex Erviti on 2/13/17.
//  Copyright © 2017 Alejandro Erviti. All rights reserved.
//

import XCTest
import Foundation
@testable import Hangman

class HangmanTests: XCTestCase {
    
    var hangman: Hangman!;
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        hangman = Hangman();
        do{
            try hangman.startOnePlayerGame();
        }
        catch {
            print("error");
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGame() {
        hangman = Hangman();
        hangman.startTwoPlayerGame("TEST");
        do {
            let outcome = try hangman.guessLetter("E");
            XCTAssertTrue(outcome == Game.GameOutcome.correctGuess);
            print(hangman.currentGame!.getCurrentGuess());
        }catch {
            
        }
    }
    
    func testRESTAPI() {
        while (hangman.currentGame == nil) {
        }
        print(hangman.currentGame?.word ?? "No Game");
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
