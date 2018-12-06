//
//  MainViewController.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit
import AVFoundation

//Class that controlls the home screen
class MainViewController: UIViewController {

    //Outlet for new game
    @IBOutlet weak var newGameBtn: UIButton!
    //outlet for leaderboard
    @IBOutlet weak var leaderboardBtn: UIButton!
    //Outlet fir continuing
    @IBOutlet weak var continueGameBtn: UIButton!
    
    //Shared instance of saved game
    static var savedState: GameState = GameState(towerHealth: 1000, wave: 0, score: 0, coins: 0, monsters: [], outposts: [nil, nil, nil, nil], castle: nil, meteorTime: 0)
    
    //File path from url
    static var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
    }
    
    //Music player object
    var musicPlayer = AVAudioPlayer()
    
    /* Function that prepares audio files for playing */
    func prepareMusicandSession(){
        //Catch exception
        do {
            //Create musicplayer from url
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ambient_music", ofType: "mp3")!))
            //Prepare
            musicPlayer.prepareToPlay()
            //Infinitely loop
            musicPlayer.numberOfLoops = Int.max
            
            //Craete shared instance
            let audioSession = AVAudioSession.sharedInstance()
            //Catch exception
            do {
                //Set category
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                //Catch block
            } catch let sessionError {
                print(sessionError)
            }
            //Catch block
        } catch let musicPlayerError {
            print(musicPlayerError)
        }
    }
    
    /* Function that loads the shared save game */
    static func loadData(){
        //Retreive from file
        if let savedData = NSKeyedUnarchiver.unarchiveObject(withFile: MainViewController.filePath) as? GameState {
            //Assign
            savedState = savedData
        }
    }
    
    /* Function that saves the current savedState to file */
    static func save() {
        //Store in file
        NSKeyedArchiver.archiveRootObject(MainViewController.savedState, toFile: MainViewController.filePath)
    }
    
    /* Function called when view is loaded */
    override func viewDidLoad() {
        //Prepare audio files
        prepareMusicandSession()
        //play music
        musicPlayer.play()
    }
    
    /* Function called everytime a view is about appear */
    override func viewWillAppear(_ animated: Bool) {
        //Call parent
        super.viewWillAppear(true)
        
        //REtrieve current time
        let currentTime = musicPlayer.currentTime
        //Play music from time
        musicPlayer.play(atTime: currentTime)
        
        //Load saved state
        MainViewController.loadData()
        
        //Check if saved state is balnk
        if  (MainViewController.savedState.towerHealth == 1000 || MainViewController.savedState.towerHealth == 0 ) && MainViewController.savedState.score == 0 {
            MainViewController.savedState = GameState(towerHealth: 1000, wave: 0, score: 0, coins: 0, monsters: [], outposts: [nil, nil, nil, nil], castle: nil, meteorTime: 0)
            //Dont show continue button
            continueGameBtn.isHidden = true
            continueGameBtn.isEnabled = false
            return
        }
        //Show continue button
        continueGameBtn.isHidden = false
        continueGameBtn.isEnabled = true
    }
    
    /* Function called when Continue is clicked */
    @IBAction func continueClicked(_ sender: Any) {
        //Stop music
        musicPlayer.stop()
        //Send over saved data
        performSegue(withIdentifier: "continueGame", sender: continueGameBtn)
    }
    
    /* Function called when New Game is clicked */
    @IBAction func newGameClicked(_ sender: Any) {
        //Stop music
        musicPlayer.stop()
        //Send over saved data
        performSegue(withIdentifier: "continueGame", sender: newGameBtn)
    }
    
    /* Function called when "Rules" button is clicked */
    @IBAction func RulesClicked(_ sender: Any) {}
    
    /* Function called when "Leaderboard" button is clicked */
    @IBAction func leaderBoardClicked(_ sender: Any) {}
    
    /* Function that defines what to do when sending to next viewcontroller */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Cast down to specific viewcontroller
        guard let gameView = segue.destination as? GameViewController else{
            return
        }
        
        guard let senderbtn = sender as? UIButton else {
            return
        }
        
        if senderbtn == continueGameBtn {
        //Send savedstate
        gameView.savedState = MainViewController.savedState
        //Send load
        gameView.isLoaded = true
        gameView.score = MainViewController.savedState.score
        gameView.coins = MainViewController.savedState.coins
        gameView.wave =  MainViewController.savedState.wave
        //Send health based on blanks state ir not
        if MainViewController.savedState.towerHealth == 0  {
            gameView.towerHealth = 1000
        }else {
            gameView.towerHealth = MainViewController.savedState.towerHealth
        }
        }else {
            gameView.savedState = MainViewController.savedState
            gameView.isLoaded = false
        }
    }
    
}
