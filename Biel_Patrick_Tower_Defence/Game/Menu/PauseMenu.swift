//
//  PauseMenu.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit
import SpriteKit

//Class used to make pause menu
class PauseMenu: SKShapeNode {
    //Parent
    let inScene: SKScene
    //Buttons visible
    let resumeButton: SKButtonNode
    let quitButton: SKButtonNode
    let saveAndQuitButton: SKButtonNode
    //Store original wave
    let originalWave: Int
    
    /* Base init */
    init(scene: SKScene, wave: Int) {
        self.inScene = scene
        self.originalWave = wave
        //Initialize resume button
        resumeButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        resumeButton.setButtonLabel(title: "Resume Game", font: "Helvetica", fontSize: 20)
        resumeButton.size = CGSize(width: 300, height: 50)
        resumeButton.position = CGPoint(x:0, y: 75)
        //Initialize quit button
        quitButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        quitButton.setButtonLabel(title: "Quit Game", font: "Helvetica", fontSize: 20)
        quitButton.size = CGSize(width: 300, height: 50)
        quitButton.position = CGPoint(x:0, y: -75)
        //Initialize save and quit button
        saveAndQuitButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        saveAndQuitButton.setButtonLabel(title: "Save and Quit Game", font: "Helvetica", fontSize: 20)
        saveAndQuitButton.size = CGSize(width: 300, height: 50)
        saveAndQuitButton.position = CGPoint(x:0, y: 0)
        
        super.init()
        //Make rectangle and form menu in that shape
        let rect = CGRect(origin: CGPoint(x: -150, y: -150), size: CGSize(width: 300, height: 300))
        self.path = CGPath(rect: rect, transform: nil)
        zPosition = 10000
        lineWidth = 1
        fillColor = .blue
        strokeColor = .white
        glowWidth = 0.5
        
        //Give buttons actions and add to scene
        quitButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(PauseMenu.quitAction))
        addChild(quitButton)
        resumeButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(PauseMenu.resumeAction))
        addChild(resumeButton)
        saveAndQuitButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(PauseMenu.quitAndSave))
        addChild(saveAndQuitButton)
    }
    
    /* Required init for decoding */
    required init?(coder aDecoder: NSCoder) {
        //Decode all members
        originalWave = 0
        if let sceneObj = aDecoder.decodeObject(forKey: "scene") as? SKScene {
            inScene = sceneObj
        }else {inScene = SKScene(size: CGSize(width: 0, height: 0))}
        saveAndQuitButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        quitButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        resumeButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        super.init(coder: aDecoder)
    }
    
    /* Function called to encode data */
    override func encode(with aCoder: NSCoder) {
        //Call paernt
        super.encode(with: aCoder)
    }
    
    /* Function that defines action when "Resume" button is clicked */
    @objc func resumeAction(){
        //Create Instance of game
        guard let gameScene = inScene as? GameScene else {
            return
        }
        //Resume game
        gameScene.isPlaying = true
        gameScene.wave = originalWave
        
        //Unpause all enemies
        for enemy in
            gameScene.enemiesCreated {
            if enemy.parent == nil {
                continue
            }
            enemy.isPaused = false
        }
        
        //Remove menu
        removeFromParent()
    }
    
    /* Function that defines action when "Quit" button is clicked */
    @objc func quitAction(){
        //Create Instance of game
        guard let gameScene = inScene as? GameScene else {
            return
        }
        //Save blank save into state
        MainViewController.savedState = GameState(towerHealth: 1000, wave: 0, score: 0, coins: 0, monsters: [], outposts: [nil, nil, nil, nil], castle: nil, meteorTime: 0)
        MainViewController.save()
        //Exit viewcontroller
        gameScene.viewController?.dismiss(animated: true)
        
    }
    
    /* Function that defines action when "Quit and Save" button is clicked */
    @objc func quitAndSave(){
        //Create Instance of game
        guard let gameScene = inScene as? GameScene else {
            return
        }
        
        //Save game members into save
        MainViewController.savedState = GameState(towerHealth: gameScene.castle!.health, wave: gameScene.wave, score: gameScene.score, coins: gameScene.coins, monsters: gameScene.enemiesCreated, outposts: gameScene.outposts, castle: gameScene.castle!, meteorTime: gameScene.meteorTimer.secondsLeft)
        MainViewController.save()
        //Exit viewcontroller
        gameScene.viewController?.dismiss(animated: true)
        
    }
    
}
