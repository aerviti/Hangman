
Hangman Project by Alejandro Erviti
Github: https://github.com/aerviti/Hangman

///////////////Running The Code///////////////
*****(Apple Login & Mac device required)*****

1. Download & Install Xcode 8.2.1 (latest release) from https://developer.apple.com/download/
2. Run the Hangman.xcodeproj file in Xcode (in a directory with all provided folders and files)
3. At the top left select “Hangman > iPhone Device” and select device for the project to be run on
	- To run simulator select an iPhone device under “iOS Simulator” header 
	  (Preferably iPhone6, 6s, or 7)
	- To run on your iOS device, plug into computer and select it under “Device” header
4. Press play button (|>) at the the top left to run the program



////////////////Game Features////////////////

* Single Player Game
   - Generate words based off of 3 options: Difficulty (1-10), Word Length Minimum (2-12), 
     Word Length Maximum (2-12)
* Two Player Game
   - Enter your own word for a friend to guess
* Changeable Guess Limit
   - Change the guess limit anywhere from 1 to 20 for one and two player games
* Single Player Scoring System
   - Get scored based on the selected options and your correct guess number
* Guessing Keyboard
   - Easily guess letters by tapping on the letter you want to guess
   - Keys of already guessed letters are automatically disabled
   - Guess a word to minimize your correct guess number for maximum points
* Updating Hangman Image As You Guess
   - A 6 piece hangman image updates as you guess incorrectly
   - For guess limits other than 6, parts of the hangman will slowly increase in opacity 
     for fluidity
* Autofill Secret Word On Loss
   - In case of a loss, missing letters will appear in red
* Single Player Statistic Tracking
   - Total score, total games, wins, losses, win:loss ratio, average winning guess number, best 
     winning guess number, and best score all persistently tracked for the user
   - Filter statistics based on difficulty, word length, and guess limit



///////////////Code Structure///////////////

The code has been written in Swift and divided into two folders found in the Hangman directory. The backend code that runs the game, stores and manages the statistics, and handles all game arguments is found in the “Data Structures” folder. All of the front end code dealing with UI is found in the “View Controllers” folder. Several classes found in the “View Controllers” folder also have links to visual Interface Builder objects found in the Main.storyboard file (These links are normally marked with @IBOutlet or @IBAction).


I. DATA STRUCTURES
The back end is split into four classes: 

Game: The Game class represents a game of hangman. Given a word and a guess limit (and difficulty for statistical usage), an instance is created. The given word is automatically capitalized to eliminate case sensitivity. This class contains two major functions in which you can interact with the game: guessLetter(_:Character) and guessWord(_:String). Upon calling one of these functions, the guess is processed and a GameOutcome is returned. A GameOutcome is an enumeration within the Game class that represents the six potential outcomes of a guess (game over, win guess, loss guess, already guessed, correct guess, incorrect guess). Previous guesses are stored in a Set to check for duplicate guesses. The current state of the guess word can be accessed through a character array, where unguessed characters are underscores. A win is returned if the number of revealed letters matches the length of the word. A loss is returned if the number of invalid guesses matches the max guesses allowed.

Hangman: The Hangman class is the outer class that runs games, stores options, and stores an instance of Statistics. Aside from several functions that access properties within the Hangman class and the currently stored Game class to provide an abstraction barrier, there are four functions in which you can interact with. There is startOnePlayerGame() that pulls a word from the Dictionary API and creates a new game with the current Hangman instance’s options. There is also a startTwoPlayerGame(_:String) that, given a string, creates a game with that string. Both of these functions funnel into startGame(_:String,_:Int) that creates a game with the current Hangman instance’s options and the provided word and difficulty. There is also a guessLetter(_:Character) and guessWord(_:String) function that acts as the middleman for the same functions within the Game class. Along with passing the arguments along, these functions check to see if the GameOutcome is a win or loss, and registers the game in the stored Statistics instance for stat recording.

Statistics: The Statistics class stores statistics from finished single player games only. It contains a score property measuring the total score across all finished games. It also contains a StatLine representing stats for all games and three arrays for each game option: Difficulty, Word Length, and Guess Max. These arrays contain StatLine instances with the appropriate stats where the array index represents the value for each option. (ex: Difficulty[1] contains a StatLine that represents stats from games with a difficulty of 1.) There are three functions in which you can interact with. storeGame(_:Game) stores the game in the appropriate StatLine instances. getStat(_:StatType,_:Int) returns a StatLine given a stat type and stat value. getScore(_:Game) returns an integer representing the score of the given game based off a custom algorithm.

StatLine: The StatLine class stores total games, wins, losses, average winning guess number, and the best winning guess number. It contains a storeGame(_:Game) function that pulls the game’s stats and stores them in the appropriate properties.

NOTE: All these objects (except Game) inherit from NSCoding which requires a few functions. These functions are used for storing data within the device.


II. VIEW CONTROLLERS
A view controller manages a view that you see on your device (or the simulator). There are four total view controllers used for each screen in the application.

TitleViewController: Manages the title screen and its views, buttons, etc. This is the instance where the Hangman instance is loaded.

OptionsViewController (+OptionsTableViewCell, WordTableViewCell): Loads in options to a UITableView depending on if the view controller was segued from a One Player button press or Two Player button press. In a single player game, this is where Hangman options can be changed through a UIStepper (difficulty, word length minimum, word length max, and guess limit). In a two player game, this is where the guess limit can be changed and an appropriate word entered. This is also where two player words are filtered. The text box requires you to enter a word between 2 and 12 characters and it must only contain letters. If not, the Play button is disabled.

GameViewController (+SecretWordView, KeyboardView, KeyboardButton): Loads up the current game of the Hangman instance. The SecretWordView creates a visual for the secret word (originally just underscores) and is updated as guesses are registered. The KeyboardView is drawn with 26 KeyboardButtons each representing a letter of the alphabet, and another KeyboardButton for guessing words. When a button is pressed, a guess is registered, and the SecretWordView and hangman picture is updated based on the GameOutcome. The hangman picture contains only 6 pieces, but will update opacity based on a fraction calculated in Hangman to accommodate guess limits that do not equal 6. This is where guessLetter() and guessWord() arguments are filtered. Each keyboard button only represents a capital letter (to avoid case sensitivity). Entered words are filtered by length/character composition and capitalized (to avoid case sensitivity).

StatsViewController (+StatsTableViewCell): Loads up the Hangman instance’s total statistics and score at the top of the page. The cells in the table are updated based on the modifier which can be changed through a UIPicker (slot wheel). The default is set to Difficulty.
