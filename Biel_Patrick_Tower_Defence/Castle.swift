//
//  Castle.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/* Class to represent main base */
class Castle: Base {
    //Ranged Damage
    var rangedDmg = 25
    //Melee Damage
    var meleeDmg = 45
    
    /* Base Initializer */
    override init(_ inScene: SKScene, imageNamed: String, attacks: [DamageTypes]){
        //Call parent init
        super.init(inScene, imageNamed: imageNamed, attacks: attacks)
        //Assign health
        health = 1000
        //Set zPosition
        zPosition = 101
        //Assign timer
        timers[0].damage = meleeDmg
        timers[1].damage = rangedDmg
        //Assign upgrade costs
        damageOutoutUpgradeCost = 45
        rangeUpgradeCost = 60
        cooldownUpgradeCost = 70
    }
    
    /* Initializer for decoding */
    required init?(coder aDecoder: NSCoder) {
        //Decode ranged damage
        rangedDmg = aDecoder.decodeInteger(forKey: "rangedDmg")
        //Decode melee damage
        meleeDmg = aDecoder.decodeInteger(forKey: "meleeDmg")
        //Call parent init
        super.init(coder: aDecoder)
    }
    
    /* Function to encode data */
    override func encode(with aCoder: NSCoder) {
        //Encode ranged
        aCoder.encode(rangedDmg, forKey: "rangedDmg")
        //Encode melee damage
        aCoder.encode(meleeDmg, forKey: "meleeDmg")
        //Encode parent
        super.encode(with: aCoder)
    }
    
    /* Function that updates labels hralth with label */
    override func updateLabel() {
        label.text =  "Health: \(health)"
    }
    
    /* Function that spawns */
    override func spawn() {
        //Spawn Parent
        super.spawn()
        //Set name for collisions
        name = "tower"
        //Set position of all ranges
        for range in ranges {
            range.position = CGPoint(x: 0, y: -30)
        }
        
    }
    
}
