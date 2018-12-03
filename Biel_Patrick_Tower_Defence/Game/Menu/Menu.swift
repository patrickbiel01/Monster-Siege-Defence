//  Menu.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit
import SpriteKit

//Class for bringing up menu
class Menu: SKShapeNode {
    
    //Subelements of Menu
    let inScene: SKScene
    var layout: [SKButtonNode]
    let type: SKButtonNode
    var labels: [SKLabelNode] = []
    
    //Dimensions of buttons
    let HEIGHT = 75
    let WIDTH = 250
    
    //Font Attributes
    let FONT = "Helvetica"
    let FONT_SIZE: CGFloat = 25
    
    /* Base Init */
    init(scene: SKScene, _ type: SKButtonNode) {
        inScene = scene
        self.type = type
        layout = []
        super.init()
        //Create rectangle and assign it to menu
        let rect = CGRect(origin: CGPoint(x: inScene.frame.width / 2 - 275, y: inScene.frame.height / 2 - 500), size: CGSize(width: 250, height: 400))
        self.path = CGPath(rect: rect, transform: nil)
        zPosition = 100000
        lineWidth = 1
        let skyBlue = UIColor(red: 0, green: 112 / 256, blue: 255 / 256, alpha: 1)
        fillColor = skyBlue
        strokeColor = .white
        glowWidth = 0.5
        
        guard let gameScene = inScene as? GameScene else {
            return
        }

        //If type specific was add
        if type == gameScene.addButton {
        /* Bring up a specific layout */
            layout = [SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil),
                          
                          SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil),
                          
                          SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil),
                          
                          SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil),
                          ]
            //Append first entry
            addChild(layout[0])
            //Set action
            layout[0].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.addMeleeTower))
            layout[0].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[0].position = CGPoint(x:inScene.frame.width / 2 - 150, y:CGFloat(3*HEIGHT))
            //Make Labels
            createLabel(gameScene: gameScene, button: layout[0], type: "")
            layout[0].setButtonLabel(title: "Add Melee Tower", font: FONT, fontSize: FONT_SIZE)
            createLabel(gameScene: gameScene, button: layout[0], type: "add")
            
            //Append second entry
            addChild(layout[1])
            //Set action
            layout[1].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.addRangedTower))
            layout[1].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[1].position = CGPoint(x:inScene.frame.width / 2 - 150, y:CGFloat(2*HEIGHT) - 20)
            layout[1].setButtonLabel(title: "Add Archery Tower", font: FONT, fontSize: FONT_SIZE)
            createLabel(gameScene: gameScene, button: layout[1], type: "add")
            
            //Append thrird entry
            addChild(layout[2])
            //Set action
            layout[2].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.addIceTower))
            layout[2].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[2].position = CGPoint(x:inScene.frame.width / 2 - 150, y:CGFloat(HEIGHT) - 40)
            //Make Labels
            layout[2].setButtonLabel(title: "Add Ice Wizard Tower", font: FONT, fontSize: FONT_SIZE)
            createLabel(gameScene: gameScene, button: layout[2], type: "add")
            
            //Append fourth entry
            addChild(layout[3])
            //Set action
            layout[3].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.addFireTower))
            layout[3].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[3].position = CGPoint(x:inScene.frame.width / 2 - 150, y:-60)
            //Make Labels
            layout[3].setButtonLabel(title: "Add Fire Wizard Tower", font: FONT, fontSize: FONT_SIZE)
            createLabel(gameScene: gameScene, button: layout[3], type: "add")
            //If type specific was upgrade
        }else if type == gameScene.upgradeButton {
            /* Bring up a specific layout */
            layout = [SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil), SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil), SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)]
            
            //Setup button with labels and action
            layout[0].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.upgradeDamageAction))
            layout[0].setButtonLabel(title: "Increase Damage", font: FONT, fontSize: FONT_SIZE)
            layout[0].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[0].position = CGPoint(x:inScene.frame.width / 2 - 150, y:CGFloat(3*HEIGHT))
            addChild(layout[0])
            createLabel(gameScene: gameScene, button: layout[0], type: "damage")
            
            //Setup button with labels and action
            layout[1].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.upgradeRange))
            layout[1].setButtonLabel(title: "Increase Range", font: FONT, fontSize: FONT_SIZE)
            layout[1].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[1].position = CGPoint(x:inScene.frame.width / 2 - 150, y:CGFloat(2*HEIGHT) - 20)
            addChild(layout[1])
            createLabel(gameScene: gameScene, button: layout[1], type: "range")
            
            //Setup button with labels and action
            layout[2].setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(Menu.upgradeCooldown))
            layout[2].setButtonLabel(title: "Decrease Cooldown", font: FONT, fontSize: FONT_SIZE)
            layout[2].size  = CGSize(width: WIDTH, height: HEIGHT)
            layout[2].position = CGPoint(x:inScene.frame.width / 2 - 150, y:CGFloat(HEIGHT-40))
            addChild(layout[2])
            createLabel(gameScene: gameScene, button: layout[2], type: "cooldown")
        }
        
    }
    
    /* Function that removes the menu from view */
    func close(){
        removeFromParent()
    }
    
    /*  Function that creates an extra cost label in a button */
    func createLabel(gameScene: GameScene, button: SKButtonNode, type: String){
        
        //Format button labels
        button.label.position.y += 10
        let label = SKLabelNode()
        label.fontSize = FONT_SIZE
        label.fontColor = UIColor.black
        label.position = CGPoint(x: button.position.x, y: button.position.y - 20)
        label.zPosition = 100
        
        //Check for add button
        guard let clicked = gameScene.clicked else {
            label.text = "Cost: \(90)"
            addChild(label)
            return
        }
        
        //Make text depending on button
        if type == "cooldown" {
            label.text = "Cost: \(clicked.cooldownUpgradeCost * clicked.attacks.count)"
        }else if type == "damage" {
            label.text = "Cost: \(clicked.damageOutoutUpgradeCost * clicked.attacks.count)"
        }else if type == "range" {
            label.text = "Cost: \(clicked.rangeUpgradeCost * clicked.attacks.count)"
        }else if type == "add" {
            label.text = "Cost: \(90)"
        }
        
        addChild(label)
        labels.append(label)
        
    }
    
    /* Required init for decoding */
    required init?(coder aDecoder: NSCoder) {
        inScene = SKScene(size: CGSize(width: 0, height: 0))
        self.type = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_blank")), disabledTexture: nil)
        layout = []
        super.init()
    }
    
    /* Function that is called when "Add Fire Wizard Tower" button is clicked */
    @objc func addFireTower(){
        addOutpost(.Fire())
    }
    
    /* Function that is called when "Add Ice Wizard Tower" button is clicked */
    @objc func addIceTower(){
        addOutpost(.Ice())
    }
    
    /* Function that is called when "Add Archery Tower" button is clicked */
    @objc func addRangedTower(){
        addOutpost(.Ranged())
    }
    
    /* Function that is called when "Add Melee Tower" button is clicked */
    @objc func addMeleeTower(){
        addOutpost(.Melee())
    }
    
    /* Function that adds an outpost given a type */
    func addOutpost(_ type: DamageTypes){
        //Verify downcast
        guard let gameScene = inScene as? GameScene else {
            return
        }
        //Verify click
        guard let position = gameScene.positionClicked else{
            return
        }
        
        var outpost: Outpost?
        //Set outpost depending on type
        if type == .Melee() {
             outpost = Outpost(inScene, imageNamed: "tower", attacks: [.Melee()])
        }else if type == .Ranged() {
             outpost = Outpost(inScene, imageNamed: "tower", attacks: [.Ranged()])
        }else if type == .Fire() {
             outpost = Outpost(inScene, imageNamed: "tower", attacks: [.Fire()])
        }else if type == .Ice() {
             outpost = Outpost(inScene, imageNamed: "tower", attacks: [.Ice()])
        }
        
        //Initialize outpost
        outpost!.size = CGSize(width: 50, height: 50)
        outpost!.zPosition = 100
        outpost!.position = position
        outpost!.createRanges()
        
        /* Iterate through outposts, if outposts is tapped and meets conditions, add outposts */
        for i in 0...gameScene.outpostRanges.count-1 {
            if gameScene.outpostRanges[i].position == outpost!.position {
                if gameScene.coins < outpost!.ADD_COST || gameScene.taken[i] {
                    //Check for availability
                    if gameScene.taken[i] {
                        Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "The position selected is already occupied")
                        //Check for coins
                    }else if gameScene.coins < outpost!.ADD_COST {
                        Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
                    }
                    return
                }
                //Add outpost
                gameScene.coins -= outpost!.ADD_COST
                gameScene.outposts[i] = outpost
                gameScene.taken[i] = true
            }
        }
        //Play spound effect
        gameScene.run(SKAction.playSoundFileNamed("building_sound", waitForCompletion: false))
        //Delay 1.4 sec
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
            //Add to scene
            gameScene.addChild(outpost!)
        }
    }
    
    
    /* Function that is called when "Increase Damage" button is clicked */
    @objc func upgradeDamageAction(){
        guard let gameScene = inScene as? GameScene else {
            return
        }
        
        if gameScene.clicked == nil {
            return
        }
        //Check if castle was clicked
        guard let outpost = gameScene.clicked as? Outpost else {
            //Downcast
            if let castle = gameScene.clicked as? Castle {
                //Check for cost
                if gameScene.coins < castle.damageOutoutUpgradeCost * 2 {
                    Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
                    return
                }
                //Increment all timers
                for timer in gameScene.clicked!.timers {
                    timer.damage += 20
                    gameScene.coins -= castle.damageOutoutUpgradeCost
                }
                //Increase cost
                castle.damageOutoutUpgradeCost *= 2
                //labels[0].text = "Cost: \(castle.damageOutoutUpgradeCost)"
            }
            return
        }
        //Check availability
        var taken = false
        for i in 0...gameScene.outposts.count-1 {
            if outpost == gameScene.outposts[i]{
                taken = gameScene.taken[i]
            }
        }
        
        //Check for availabilty and cost
        if gameScene.coins < outpost.damageOutoutUpgradeCost || !taken {
            if gameScene.coins < outpost.damageOutoutUpgradeCost {
                Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
            }
            return
        }
        //Change properties to decrease cooldown
        outpost.timers[0].damage += 30
        gameScene.coins -= outpost.damageOutoutUpgradeCost
        outpost.damageOutoutUpgradeCost *= 2

    }
    
    /* Function that is called when "Increase Range" button is clicked */
    @objc func upgradeRange(){
        guard let gameScene = inScene as? GameScene else {
            return
        }
        
        if gameScene.clicked == nil {
            return
        }
        //Check if castle was clicked
        guard let outpost = gameScene.clicked as? Outpost else {
            //Downcast
            if let castle = gameScene.clicked as? Castle {
                //Check for cost and limit
                if gameScene.coins < castle.rangeUpgradeCost * 2 {
                    Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
                    return
                }else if castle.rangeUpgradeCount > 3 {
                    Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "No more upgrades available")
                    return
                }
                //Increment all ranges
                for range in gameScene.clicked!.ranges {
                    range.setScale(1.2)
                    gameScene.coins -= castle.rangeUpgradeCost
                }
                //Increase cost
                castle.rangeUpgradeCost *= 2
                castle.rangeUpgradeCount += 1
                
            }
            return
        }
        //Check availability
        var taken = false
        for i in 0...gameScene.outposts.count-1 {
            if outpost == gameScene.outposts[i]{
                taken = gameScene.taken[i]
            }
        }
        
        if gameScene.coins < outpost.rangeUpgradeCost || !taken || outpost.rangeUpgradeCount > 3 {
            if gameScene.coins < outpost.rangeUpgradeCost * 2 {
                Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
            }else if outpost.rangeUpgradeCount >= 3 {
                Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "No more upgrades available")
            }
            return
        }
        
        //Change properties to decrease cooldown
        outpost.ranges[0].setScale(1.2)
        gameScene.coins -= outpost.rangeUpgradeCost
        outpost.rangeUpgradeCost *= 2
        
    }
    
    /* Function that is called when "Decrease Cooldown" button is clicked */
    @objc func upgradeCooldown(){
        guard let gameScene = inScene as? GameScene else {
            return
        }
        
        if gameScene.clicked == nil {
            return
        }
        
        //Check if castle was clicked
        guard let outpost = gameScene.clicked as? Outpost else {
            //Downcast
            if let castle = gameScene.clicked as? Castle {
                //Check for cost and limit
                if gameScene.coins < castle.cooldownUpgradeCost * 2 {
                    Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
                    return
                }else if castle.cooldownUpgradeCount > 3 {
                    Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "No more upgrades available")
                    return
                }
                //Increment all timers
                for timer in castle.timers {
                    timer.originalTime -= 0.3
                    gameScene.coins -= castle.cooldownUpgradeCost
                }
                //Increase cost
                castle.cooldownUpgradeCost *= 2
                castle.cooldownUpgradeCount += 1
                
            }
            return
        }
        
        //Check availability
        var taken = false
        for i in 0...gameScene.outposts.count-1 {
            if outpost == gameScene.outposts[i]{
                taken = gameScene.taken[i]
            }
        }
        
        //Check for availabilty and cost
        if gameScene.coins < outpost.cooldownUpgradeCost || !taken || outpost.cooldownUpgradeCount > 3 {
            if gameScene.coins < outpost.damageOutoutUpgradeCost {
                Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "Not enough Coins")
            }else if outpost.cooldownUpgradeCount >= 3 {
                Toast().showAlert(backgroundColor: UIColor.lightGray, textColor:UIColor.black, message: "No more upgrades available")
            }
            return
        }
        
        //Change properties to decrease cooldown
        outpost.timers[0].originalTime -= 0.3
        gameScene.coins -= outpost.cooldownUpgradeCost
        outpost.cooldownUpgradeCost *= 2
    }
    
}
