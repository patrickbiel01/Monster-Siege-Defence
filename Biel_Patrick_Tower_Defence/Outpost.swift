//
//  Outpost.swift
//  Biel_Patrick_Tower_Defence
//
//  Created by Period Three on 2018-05-16.
//  Copyright © 2018 Period Three. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

//Class to represent outposts
class Outpost: Base {
    //Damage output
    var damageOutput: Int = 0
    //Cost to add outpost
    let ADD_COST = 90
    
    /* Base Initializer */
    override init(_ inScene: SKScene, imageNamed: String, attacks: [DamageTypes]){
        //Call parent init
        super.init(inScene, imageNamed: imageNamed, attacks: attacks)
        /* Assign damage output based on attack */
        for attack in attacks {
            switch attack {
            case .Melee():
                damageOutput = 75
            case .Ranged() :
                damageOutput = 50
            case .Fire:
                damageModifier = 5
            case .Ice:
                damageModifier = 5
            case .None:
                damageModifier = 5
            }
            
        }
        //Assign health
        health = 1
        //Assign damage cost
        damageOutoutUpgradeCost = 55
        //Assign range cost
        rangeUpgradeCost = 60
        //Assign upgrade cost
        cooldownUpgradeCost = 70
    }
    
    /* Init for decoding */
    required init?(coder aDecoder: NSCoder) {
        //Call parent init
        super.init(coder: aDecoder)
    }
    
    /* Function for encoding */
    override func encode(with aCoder: NSCoder) {
        //Encode parent
        super.encode(with: aCoder)
    }
}
