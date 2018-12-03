//
//  Monster.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Darwin

/* Class to represent the enemies */
class Monster: Actor {
    //Key for actions
    public static let ACTION_KEY = "sequence"
    //Pi
    let PI = 3.14159265
    //Member for attack damage
    var attackDmg = 0
    //Stores state of enemy
    var isAttacking = false
    //Stores collision point with castle
    var collisionPoint: CGPoint?
    //Member for speed
    var runSpeed: Int = 0
    //Member for  attack delay
    var attackDelay = 0
    //Variable for resistance
    var resistance: DamageTypes = .None()
    //Stores saved action
    var actions: SKAction?
    
    /* Base initializer */
    init(imageNamed: String, inScene scene: SKScene, attributes: MonsterAttributes) {
        //Call parent init
        super.init(imageNamed: imageNamed, inScene: scene, size:
        100)
        //Set resistance
        resistance = attributes.resistance
        //Set attack damage
        attackDmg = attributes.attackDmg
        //Set runspeed
        runSpeed = attributes.runSpeed
        //Set attack delay
        attackDelay = attributes.attackDelay
        //Set health
        health = attributes.health
        //Set zPosition
        zPosition = 55
    }
    
    /* Initilazer for decoding */
    required init?(coder aDecoder: NSCoder) {
        //Decode Action
        if let actions = aDecoder.decodeObject(forKey: Monster.ACTION_KEY) as? SKAction {
            //Assign decoded
            self.actions = actions
        }
        //Decode attack damage
        attackDmg = aDecoder.decodeInteger(forKey: "attackDmg")
        //Decode state
        isAttacking = aDecoder.decodeBool(forKey: "isAttacking")
        //Decode speed
        runSpeed = aDecoder.decodeInteger(forKey: "runSpeed")
        //Decode attack delay
        attackDelay = aDecoder.decodeInteger(forKey: "attackDelay")
        //Decode collision point
        if let collisionPointObj = aDecoder.decodeObject(forKey: "collisionPoint") as? CGPoint {
            //Assign decoded
            collisionPoint = collisionPointObj
        }else {collisionPoint = nil}
        //Decode resistance
        if let resistanceObj = aDecoder.decodeObject(forKey: "resistance") as? String {
            switch resistanceObj {
            /* Assign enum based on string retrieved */
            case "Melee":
                resistance = .Melee()
            case "Ranged":
                resistance = .Ranged()
            case "Fire":
                resistance = .Fire()
            case "Ice":
                resistance = .Ice()
            default :
                resistance = .None()
            }
        }else {resistance = .None()}
        //Call parent init
        super.init(coder: aDecoder)
        //Set zPosition
        zPosition = 55
    }
    
    /* Function to encode data */
    override func encode(with aCoder: NSCoder) {
        //Encode attack
        aCoder.encode(actions, forKey: Monster.ACTION_KEY)
        //Encode parent
        super.encode(with: aCoder)
        //Encode attack damage
        aCoder.encode(attackDmg, forKey: "attackDmg")
        //Encode state
        aCoder.encode(isAttacking, forKey: "isAttacking")
        //Encode collision point
        aCoder.encode(collisionPoint, forKey: "collisionPoint")
        //Encode speed
        aCoder.encode(runSpeed, forKey: "runSpeed")
        //Encode delay
        aCoder.encode(attackDelay, forKey: "attackDelay")
        //Encode string version of resistance
        aCoder.encode(resistance.rawValue(), forKey: "resistance")
    }
    
    /* Function to move enemies toward castle */
    func moveToCenter(){
        run(actions!, withKey: Monster.ACTION_KEY)
    }
    
    /* Function that creates random path towards center */
    private final func generateSequence() -> SKAction {
        //Actions
        var action: [SKAction] = []
        //Generate random number
        let rand = arc4random_uniform(2)
        
        /* Based on spawn position */
        if position.x > 0 {
            //Move forward
            action.append(SKAction.move(to: CGPoint(x:350, y:0), duration: TimeInterval(runSpeed)))
            switch rand {
            case 0:
            //Rotate and move forward
            action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: 350, y:0), endPosition: CGPoint(x: 250, y:150)), duration: 0.1))
                action.append(SKAction.move(to: CGPoint(x: 250, y:150), duration: TimeInterval(runSpeed)))
            if runSpeed == 5 {
                action.append(SKAction.rotate(toAngle: .pi, duration: 0.1))
            }else {
                action.append(SKAction.rotate(toAngle: 0, duration: 0.1))
            }
                action.append(SKAction.move(to: CGPoint(x: 175, y:150), duration: TimeInterval(runSpeed)))
            //Rotate and move to center
            action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: 175, y:150), endPosition: CGPoint.zero), duration: 0.1))
                action.append(SKAction.move(to: CGPoint.zero, duration: TimeInterval(runSpeed)))
            case 1:
                //Rotate and move forward
                action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: 350, y:0), endPosition: CGPoint(x: 250, y:-150)), duration: 0.1))
                action.append(SKAction.move(to: CGPoint(x: 250, y:-150), duration: TimeInterval(runSpeed)))
                if runSpeed == 5 {
                    action.append(SKAction.rotate(toAngle: .pi, duration: 0.1))
                }else {
                    action.append(SKAction.rotate(toAngle: 0, duration: 0.1))
                }
                action.append(SKAction.move(to: CGPoint(x: 175, y:-150), duration: TimeInterval(runSpeed)))
                //Rotate and move to center
                action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: 175, y:-150), endPosition: CGPoint.zero), duration: 0.1))
                action.append(SKAction.move(to: CGPoint.zero, duration: TimeInterval(runSpeed)))
            default:
                print("Error")
            }
        }else {
            //Move forward
            action.append(SKAction.move(to: CGPoint(x:-350, y:0), duration: TimeInterval(runSpeed)))
            switch rand {
            case 0:
                //Rotate and move forward
                action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: -350, y:0), endPosition: CGPoint(x: -250, y:150)), duration: 0.1))
                
                action.append(SKAction.move(to: CGPoint(x: -250, y:150), duration: TimeInterval(runSpeed)))
                action.append(SKAction.rotate(toAngle: 0, duration: 0.1))
                
                action.append(SKAction.move(to: CGPoint(x: -175, y:150), duration: TimeInterval(runSpeed)))
                //Rotate and move to center
                action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: -175, y:150), endPosition: CGPoint.zero), duration: 0.1))
                action.append(SKAction.move(to: CGPoint.zero, duration: TimeInterval(runSpeed)))
            case 1:
                //Rotate and move forward
                action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: -350, y:0), endPosition: CGPoint(x: -250, y:-150)), duration: 0.1))
                action.append(SKAction.move(to: CGPoint(x: -250, y:-150), duration: TimeInterval(runSpeed)))
                //Rotate and move to center
                action.append(SKAction.rotate(toAngle: 0, duration: 0.1))
                action.append(SKAction.move(to: CGPoint(x: -175, y:-150), duration: TimeInterval(runSpeed)))
            action.append(SKAction.rotate(byAngle:findTheta(currentPosition: CGPoint(x: -175, y:-150), endPosition: CGPoint.zero), duration: 0.1))
                action.append(SKAction.move(to: CGPoint.zero, duration: TimeInterval(runSpeed)))
            default:
                print("Error")
            }
        }
        //Return random path
        return SKAction.sequence(action)
    }
    
    /* Function that set properties of a monster */
    override func spawn(){
        //Create random num
        let rand = arc4random_uniform(2)
        //Create circular physicsbody
        physicsBody = SKPhysicsBody(circleOfRadius: frame.height / 2)
        //Moves around
        physicsBody?.isDynamic = true
        //No gravity
        physicsBody?.affectedByGravity = false
        //Set collision bitmasks (who to collide with)
        //Enemy category
        physicsBody?.categoryBitMask = GameScene.ENEMY_CATEGORY
        //Who to record collision with
        physicsBody?.contactTestBitMask = GameScene.PLAYER_CATEGORY
        //Who to visibily recoil with
        physicsBody?.collisionBitMask = GameScene.PLAYER_CATEGORY
        /* Set spawn position based on random number */
        switch rand {
        case 0:
            position = CGPoint(x: -inScene.size.width/2 - 130, y: 0)
        case 1:
            position = CGPoint(x: inScene.size.width/2 + 130, y: 0)
            if !(runSpeed == 10 || runSpeed == 2) {
                run(SKAction.rotate(byAngle: .pi, duration: 0.01))
            }
        default:
            position = CGPoint.zero
        }
        
        actions = generateSequence()
        
        //Add monster to scene
        inScene.addChild(self)
        //Add monster health label to scene
        inScene.addChild(label)
    }
    
    /* Function that returns angle between two points */
    func findTheta(currentPosition: CGPoint, endPosition: CGPoint) -> CGFloat{
        //Dont rotate non zombie monsters
        if runSpeed == 10 || runSpeed == 2 {
                return 0
        }
        
        //Calculate x displacement
        let displacementX = currentPosition.x - endPosition.x
        //Calculate y displacement
        let displacementY = currentPosition.y - endPosition.y
        
        //return inverse tan of y / x
       return atan(displacementY / displacementX)
        
    }
    
}
