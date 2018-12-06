//
//  GameState.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

//Class to save game data
class GameState: NSObject, NSCoding {
    //Key for saving data
    public static let KEY = "savingState"
    //Storing castle health
    let towerHealth: Int
    //Store Castle
    let castle: Castle?
    //Storing monsters
    let monsters: [Monster]
    //Storing outposts
    let outposts: [Outpost?]
    //Store wave
    let wave: Int
    //Store score
    let score: Int
    //Store coins
    let coins: Int
    //Store meteor time
    let meteorTime: Double
    
    /* Base Init */
    init(towerHealth: Int, wave: Int, score: Int, coins: Int, monsters: [Monster], outposts: [Outpost?], castle: Castle?, meteorTime: Double) {
        //Assign all members
        self.towerHealth = towerHealth
        self.monsters = monsters
        self.outposts = outposts
        self.wave = wave
        self.score = score
        self.coins = coins
        self.castle = castle
        self.meteorTime = meteorTime
    }
    
    /* Init for decoding */
    required init(coder aDecoder: NSCoder) {
        //Decode score
        score = aDecoder.decodeInteger(forKey: "score")
        //Decode wave
        wave = aDecoder.decodeInteger(forKey: "wave")
        //Decode coins
        coins = aDecoder.decodeInteger(forKey: "coins")
        //Decode health
        towerHealth = aDecoder.decodeInteger(forKey: "towerHealth")
        //Decode meteor time
        meteorTime = aDecoder.decodeDouble(forKey: "meteor")
        //retrieve ouposts
        if let outpostsObj = aDecoder.decodeObject(forKey: "outposts") as? [Outpost?] {
            outposts = outpostsObj
        }else {outposts = [nil, nil, nil, nil]}
        //Retrieve monsters
        if let monstersObj = aDecoder.decodeObject(forKey: "enemiesCreated") as? [Monster] {
            monsters = monstersObj
        }else {monsters = []}
        //Retrieve castle
        if let castle = aDecoder.decodeObject(forKey: "castle") as? Castle {
            self.castle = castle
        }else {castle = nil}
    }
    
    /* Function that encodes data */
    func encode(with aCoder: NSCoder) {
        //Encode all members
        aCoder.encode(score, forKey: "score")
        aCoder.encode(wave, forKey: "wave")
        aCoder.encode(coins, forKey: "coins")
        aCoder.encode(outposts, forKey: "outposts")
        aCoder.encode(towerHealth, forKey: "towerHealth")
        aCoder.encode(monsters, forKey: "enemiesCreated")
        aCoder.encode(castle, forKey: "castle")
        aCoder.encode(meteorTime, forKey: "meteor")
    }
    
}
