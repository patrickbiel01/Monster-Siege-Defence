//
//  Actor.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/* Base class for all characters */
class Actor: SKSpriteNode {
    //Health property
    var health: Int = 0
    //Scene member
    var inScene: SKScene = SKScene(size: CGSize(width: 1, height: 1))
    //Texture size
    var textureSize = 50
    //Health label
    var label = SKLabelNode()
    
    /* Base Initiliazer */
    init(imageNamed: String, inScene: SKScene, size: Int) {
        //Assign scene
        self.inScene = inScene
        //Set font colour
        label.fontColor = UIColor.white
        //Create new texture
        let texture = SKTexture(imageNamed: imageNamed)
        //Call parent initilazer
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: size, height: size))
        //Set label position
        label.position = CGPoint(x: position.x, y: position.y + 50)
        //Set label zPossiton
        label.zPosition = 6
    }
    
    /* Initializer for decoding */
    required init?(coder aDecoder: NSCoder) {
        //Call parent initiliazer
        super.init(coder: aDecoder)
        //Decode scene
        if let sceneObj = aDecoder.decodeObject(forKey: "inScene") as? SKScene {
            //Assign scene
            inScene = sceneObj
        }else {inScene = SKScene(size: CGSize(width: 1, height: 1))}
        //Assign health
        health = aDecoder.decodeInteger(forKey: "health")
        //Set font colour
        label.fontColor = UIColor.white
        //Set label position
        label.position = CGPoint(x: position.x, y: position.y + 50)
        //Set label zPosition
        label.zPosition = 6
    }
    
    /* Function to encode data */
    override func encode(with aCoder: NSCoder) {
        //Encode parent
        super.encode(with: aCoder)
        //Encode scene
        aCoder.encode(inScene, forKey: "inScene")
        //Encode health
        aCoder.encode(health, forKey: "health")
    }
    
    /* Function for spawning */
    func spawn(){}
    
    /* Function to update label */
    func updateLabel() {
        //Set text
        label.text = String(describing: health)
        //Update position
        label.position = CGPoint(x: position.x, y: position.y + 50)
    }
    
}
