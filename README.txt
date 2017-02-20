Hangman Project by Alejandro Erviti
Github: https://github.com/aerviti/Hangman

///////////////Running The Code///////////////
*****(Apple Login & Mac device required)*****

1. Download & Install Xcode 8.2.1 (latest release) from https://developer.apple.com/download/
2. Run the Hangman.xcodeproj file in Xcode
3. At the top left select “Hangman > iPhone Device” and select device for the project to be run on
	- To run simulator select an iPhone device under “iOS Simulator” header 
	  (Preferably iPhone6, 6s, or 7)
	- To run on your iOS device, plug into computer and select it under “Device” header
4. Press play button (|>) at the the top left to run the program



///////////////Code Structure///////////////

The code has been written in Swift and divided into two folders. The backend code that runs the game, stores and manages the statistics, and handles all game arguments is found in the “Data Structures” folder. All of the front end code dealing with UI is found in the “View Controllers” folder. Several classes found in the “View Controller” folder also have links to visual Interface Builder objects found in the Main.storyboard file (These links are normally marked with @IBOutlet or @IBAction).

I. DATA STRUCTURES

