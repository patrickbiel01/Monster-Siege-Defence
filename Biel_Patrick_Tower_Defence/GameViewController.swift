//
//  GameViewController.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

//Class that controls the GameView
class GameViewController: UIViewController {
    //Variable that stores whether game is loaded
    var isLoaded = false
    //Variable for coins
    var coins = 0
    //Variable for wave
    var wave = 0
    //Variable for score
    var score = 0
    //Variable for health
    var towerHealth = 1000
    //Variable for saved state
    var savedState: GameState?
    //Object to play music
    var musicPlayer = AVAudioPlayer()
    
    /* Function that prepares song to be played */
    func prepareMusicandSession(){
        //Catch exceptions thrown
        do {
            //Create new AVAudioPlayer from URL
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "battle_music", ofType: "wav")!))
            //Prepare song files
            musicPlayer.prepareToPlay()
            //Infinite looping
            musicPlayer.numberOfLoops = Int.max
            //Set volume
            musicPlayer.volume = 0.2
            
            //Create shared instance
            let audioSession = AVAudioSession.sharedInstance()
            //Catch exceptioons thrown
            do {
                //Set category
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch let sessionError {
                //Catch block
                print(sessionError)
            }
            
        } catch let musicPlayerError {
            //Catch block
            print(musicPlayerError)
        }
    }
    

    /* Function that is called when view is loaded */
    override func viewDidLoad(){
        //Calls parent function
        super.viewDidLoad()
        //Prepare music for playing
        prepareMusicandSession()
        //Start music
        musicPlayer.play()
        
        //Create instance of view
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                //Cast scene to GameScene
                if let gameScene = scene as? GameScene {
                    //Check save
                    if !(MainViewController.savedState.towerHealth == 1000 || MainViewController.savedState.towerHealth == 0 ) && MainViewController.savedState.score == 0 {
                        gameScene.isLoaded = true
                    }
                    //Assign saved state
                    gameScene.savedState = savedState!
                    gameScene.isLoaded = isLoaded
                    gameScene.viewController = self
                }
                // Present the scene
                view.presentScene(scene)
            }
            //Set sibling order
            view.ignoresSiblingOrder = true
        }
    }

    /* Viewcontroller should auto rotate */
    override var shouldAutorotate: Bool {
        return false
    }

    /* Property that defines supported interfaces */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    /* Function called when viewcontroller is dismissed */
    override func viewWillDisappear(_ animated: Bool) {
        //Stop music player
        musicPlayer.stop()
    }

    /* Function that removes soft keyboard after use */
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
     }
    
    /* Function that defines status bar visibility */
    override var prefersStatusBarHidden: Bool {
        //Hide status bar
        return true
    }
    
}
