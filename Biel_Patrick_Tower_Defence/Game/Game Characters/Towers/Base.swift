//
//  Base.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/* Enum to define different damage  types */
enum DamageTypes: Equatable {
    case Melee(), Ranged(), Fire(), Ice(), None()
    
    /* Returns a string version of enum name */
    func rawValue() -> String {
        if self == .Melee() {
            return "Melee"
        }else if self == .Ranged() {
            return "Ranged"
        }else if self == .Fire() {
            return "Fire"
        }else if self == .Ice() {
            return "Ice"
        }else {
            return "None"
        }
    }
    
}

/* Base class for all character controlled towers */
class Base: Actor {
    //Array of attacks
    let attacks: [DamageTypes]
    //Array if timers
    var timers: [CountDownTimer] = []
    //Array of ranges
    var ranges: [SKShapeNode] = []
    //Amount to deduct
    var damageModifier = 0
    //Member to hold cost of upgrading damage
    var damageOutoutUpgradeCost = 55
    //Member to hold cost of upgrading range
    var rangeUpgradeCost = 60
    //Member to hold cost of upgrading cooldown
    var cooldownUpgradeCost = 70
    //Range upgrade count
    var rangeUpgradeCount = 0
    //Cooldown upgrade cost
    var cooldownUpgradeCount = 0
    
    /* Base Initilazer */
    init(_ inScene: SKScene, imageNamed: String, attacks: [DamageTypes]){
        //Assign attacks
        self.attacks = attacks
        
        /* Create perspective timers that deal damage  based on attacks */
        for i in 0...attacks.count - 1 {
            if attacks[i] == DamageTypes.Melee() {
                timers.append(CountDownTimer(damage: 30))
            }else if attacks[i] == DamageTypes.Ranged() {
                timers.append(CountDownTimer(damage: 15))
            }else if attacks[i] == DamageTypes.Fire() {
                timers.append(CountDownTimer(damage: 20))
            }else if attacks[i] == DamageTypes.Ice() {
                timers.append(CountDownTimer(damage: 20))
            }
            
        }
        //Call parent init
        super.init(imageNamed: imageNamed, inScene: inScene, size: 225)
    }
    
    /* Initializer for decoding */
    required init?(coder aDecoder: NSCoder) {
        //Retrieve attacks array
       if let attacksObj = aDecoder.decodeObject(forKey: "attacks") as? [String] {
        //Create temp array
        var tempAttack: [DamageTypes] = []
        //Iterate through strings
        for string in attacksObj {
            /* Assign enum based on strig in array */
            switch string {
            case "Melee":
                tempAttack.append(.Melee())
            case "Ranged":
                tempAttack.append(.Ranged())
            case "Fire":
                tempAttack.append(.Fire())
            case "Ice":
                tempAttack.append(.Ice())
            default:
                tempAttack.append(.None())
            }
        }
        //Assign attacks
        attacks = tempAttack
       }else {attacks = []}
        //Retriev timers
        if let timerObj = aDecoder.decodeObject(forKey: "timers") as? [CountDownTimer] {
            //Asssign timers
            timers = timerObj
        }else {timers = []}
        //retrieve ranges
        if let rangesObj = aDecoder.decodeObject(forKey: "ranges") as? [SKShapeNode] {
            //ASsign ranges
            ranges = rangesObj
        }else {ranges = []}
        //Decode damage moddifier
        damageModifier = aDecoder.decodeInteger(forKey: "damageModifier")
        //Decode damage outut cost
        damageOutoutUpgradeCost = aDecoder.decodeInteger(forKey: "damageOutoutUpgradeCost")
        //Decode range outpost cost
        rangeUpgradeCost = aDecoder.decodeInteger(forKey: "rangeUpgradeCost")
        //Decode coolddown upgrade cost
        cooldownUpgradeCost = aDecoder.decodeInteger(forKey: "cooldownUpgradeCost")
        //Decode range count
        rangeUpgradeCount = aDecoder.decodeInteger(forKey: "rangeUpgradeCount")
        //Decode coolddown upgrade count
        cooldownUpgradeCount = aDecoder.decodeInteger(forKey: "cooldownUpgradeCount")
        //Decode parent
        super.init(coder: aDecoder)
    }
    
    /* Function to encode data */
    override func encode(with aCoder: NSCoder) {
        //Store attacks as string
        var attackSS: [String] = []
        for attack in attacks {
            attackSS.append(attack.rawValue())
        }
        //Encode strings
        aCoder.encode(attackSS, forKey: "attacks")
        //Encode timers
        aCoder.encode(timers, forKey: "timers")
        //Encode ranges
        aCoder.encode(ranges, forKey: "ranges")
        //Encode modifier
        aCoder.encode(damageModifier, forKey: "damageModifier")
        //Encode cost of damage
        aCoder.encode(damageOutoutUpgradeCost, forKey: "damageOutoutUpgradeCost")
        //Encode range upgrade
        aCoder.encode(rangeUpgradeCost, forKey: "rangeUpgradeCost")
        //Encode cooldown cost
        aCoder.encode(cooldownUpgradeCost, forKey: "cooldownUpgradeCost")
        //Encode range count
        aCoder.encode(rangeUpgradeCount, forKey: "rangeUpgradeCount")
        //Encode cooldown count
        aCoder.encode(cooldownUpgradeCount, forKey: "cooldownUpgradeCount")
        super.encode(with: aCoder)
    }
    
    /* Function that assign sranges */
    func createRanges(){
        //Makes sure it not called more than once
        if ranges.count >= 2 {
            return
        }
        
        //If a melee tower
        if contains(.Melee()) {
            /* Create circle around tower */
            let path = CGMutablePath()
        path.addArc(center: position,
                    radius: 150,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
            //Create node
            let ball = SKShapeNode(path: path)
            //Append to memeber
            ranges.append(ball)
        }
        
        //If a ranged tower
        if contains(.Ranged()) {
            /* Create circle around tower */
            let path = CGMutablePath()
            path.addArc(center: position,
                        radius: 350,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
            //Create node
            let ball = SKShapeNode(path: path)
            //Append to memeber
            ranges.append(ball)
        }
        
        //If a fire tower
        if contains(.Fire()) {
            /* Create circle around tower */
            let path = CGMutablePath()
            path.addArc(center: position,
                        radius: 400,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
            //Create node
            let ball = SKShapeNode(path: path)
            //Append to memeber
            ranges.append(ball)
        }
        
        //If a ice tower
        if contains(.Ice()) {
            /* Create circle around tower */
            let path = CGMutablePath()
            path.addArc(center: position,
                        radius: 400,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
            //Create node
            let ball = SKShapeNode(path: path)
            //Append to memeber
            ranges.append(ball)
        }
        
    }
    
    /* Function that determines if enemy can be attacked */
    func decideAttack(enemy: Monster){
        //Iterate through ranges
        for i in 0...ranges.count-1 {
            //If enemy is within range
            if ranges[i].contains(enemy.position) {
                //If tower is already attacking
                if timers[i].isAttacking {
                    continue
                }
                //Start timer
                timers[i].startTimer()
                //Attack enemy
                animateAttack(enemy: enemy, attackType: attacks[i], timer: timers[i])
            }
        }
        
    }
    
    /* Init properties of base */
    override func spawn(){
        //Set label position
        label.position = CGPoint(x:0,y: -inScene.frame.height / 2 + 30)
        //Set label font size
        label.fontSize = 52
        //Set label font colour
        label.fontColor = UIColor.green
        //Create path
        let path = CGMutablePath()
        //Define path around base
        path.addLines(between: [CGPoint(x: 0, y: -125), CGPoint(x: 110, y: -60), CGPoint(x: 110, y: -10),
                                CGPoint(x: 0, y: 120), CGPoint(x: -110, y: -10),
                                CGPoint(x: -110, y: -60), CGPoint(x: 0, y: -125)])
        path.closeSubpath()
        //Add custom body
        physicsBody = SKPhysicsBody(polygonFrom: path)
        //Not affected by gravity
        physicsBody?.affectedByGravity = false
        //Non moving
        physicsBody?.isDynamic = false
        //Define how it collides
        physicsBody?.categoryBitMask = GameScene.PLAYER_CATEGORY
        physicsBody?.contactTestBitMask = GameScene.ENEMY_CATEGORY
        physicsBody?.collisionBitMask = GameScene.ENEMY_CATEGORY
        //Create ranges
        createRanges()
        //Add base to scene
        inScene.addChild(self)
        //Add labekl to scene
        inScene.addChild(label)
    }
    
    /* Function that shows an attack */
    func animateAttack(enemy: Monster, attackType: DamageTypes, timer: CountDownTimer){
        //Store position
        let position = enemy.position
        
        /* If melee */
        if attackType == .Melee() {
            //Create sword sprite
            let sword = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "sword")), size: CGSize(width: 50, height: 50))
            //Set to enemy position
            sword.position = enemy.position
            //Set zPosition
            sword.zPosition = 100
            //Add sword to scene
            inScene.addChild(sword)
            
            /* Remove sword after quarter second */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                //Do half damage if enemy has resistance
                if enemy.resistance != attackType || enemy.resistance == .None() {
                    enemy.health -= timer.damage
                }else {
                    enemy.health -= timer.damage / 2
                }
                //Remove from scene
                sword.removeFromParent()
            }
            
        }
        
        /* If Ranged */
        if attackType == .Ranged() {
            //Create arrow sprite
            let volley = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "arrow")))
            //Set arrow size
            volley.size = CGSize(width: 50, height: 50)
            //Set volley position to position of base
            volley.position = self.position
            //Add arows to scene
            inScene.addChild(volley)
            //Set zPosition
            volley.zPosition = 99
            //Time
            let time = 0.7
            //Rotate to enemy
            volley.run(SKAction.sequence([SKAction.rotate(toAngle: findTheta(currentPosition: enemy.position, endPosition: CGPoint.zero), duration: 0.01), SKAction.move(to: position, duration: time)]))
            /* Delay by 0,7 sec */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //Deal half damage if it has a resistance
                if enemy.resistance != attackType || enemy.resistance == .None() {
                    enemy.health -= timer.damage
                }else {
                    enemy.health -= timer.damage / 2
                }
                //remove arrows from scene
                    volley.removeFromParent()
            }
            
        }
        
        /* If Fire */
        if attackType == .Fire() {
            //Create fireball sprite
            let fireball = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "star")))
            //Set size
            fireball.size = CGSize(width: 50, height: 50)
            //Set positionb
            fireball.position = self.position
            //Set zposition
            fireball.zPosition = 98
            //Add fireball to scene
            inScene.addChild(fireball)
            //Time
            let time = 0.5
            //Rotate during motion
            fireball.run(SKAction.repeatForever(SKAction.rotate(byAngle: -2 * .pi, duration: 0.5)))
            //Move to enemy position
            fireball.run(SKAction.move(to: position, duration: time))
            
            /* Delay 0,7 sec */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //Deal half damage if it has a resistance
                if enemy.resistance != attackType || enemy.resistance == .None() {
                    enemy.health -= timer.damage
                }else {
                    enemy.health -= timer.damage / 2
                }
                //REmove fireball from scene
                    fireball.removeFromParent()
            }
            
        }
        
        /* If Ice */
        if attackType == .Ice() {
            //Create iceball sprite
            let iceball = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "ice-crystal")))
            //Set size
            iceball.size = CGSize(width: 50, height: 50)
            //Set position
            iceball.position = self.position
            //Set zposition
            iceball.zPosition = 97
            //Add iceball to scene
            inScene.addChild(iceball)
            //TIme
            let time = 0.5
            //Rotate during motion
            iceball.run(SKAction.repeatForever(SKAction.rotate(byAngle: -2 * .pi, duration: time)))
            //Move to enemy position
            iceball.run(SKAction.move(to: position, duration: time))
            
            /* Delay 0,5 sec */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //Deal half damage if it has a resistance
                if enemy.resistance != attackType || enemy.resistance == .None() {
                    enemy.health -= timer.damage
                }else {
                    enemy.health -= timer.damage / 2
                }
                //Remove iceball from scenne
                iceball.removeFromParent()
            }
        }
        
    }
    
    /* Function that check if array contains value */
    func contains(_ value: DamageTypes) -> Bool{
        var returnValue = false
        //Iterate through attacks
        for i in 0 ... attacks.count - 1 {
            //Return true if present
            if attacks[i] == value {
                returnValue = true
                break
            }
        }
        //Else, return false
        return returnValue
        
    }
    
    /* Function that finds angle between 2 points */
    func findTheta(currentPosition: CGPoint, endPosition: CGPoint) -> CGFloat{
        //Find x displacement
        let displacementX = currentPosition.x - endPosition.x
        //Find y displacement
        let displacementY = currentPosition.y - endPosition.y
        
        /* Return differnent value depending on which quadrant positions are loacted in */
        
        if displacementX == 0 && displacementY > 0{
            return 3.14159265 * 2
        }else if displacementX == 0 && displacementY < 0{
            return 3.14159265
        } else if displacementX > 0 && displacementY == 0{
            return 3.14159265/2 * 3
        }else if displacementX < 0 && displacementY == 0{
            return 3.14159265 / 2
        }else {
            if displacementX < 0 && displacementY < 0 {
                return atan(displacementY / displacementX) + 3.14159265/2
            }else if displacementX < 0 && displacementY > 0 {
                return atan(displacementY / displacementX) - 3.14159265 / 2 * 3
            }else if displacementX > 0 && displacementY > 0 {
                return atan(displacementY / displacementX) - 3.14159265/2
            }else {
                return atan(displacementY / displacementX) + 3.14159265/2 * 3
            }
    }
}
    
}



