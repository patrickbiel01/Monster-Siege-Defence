//
//  GameScene.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

//Class the controls the contents of the game
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Instance of ViewController GameScene is nested in
    var viewController: UIViewController?
    
    var SCREEN_HEIGHT: CGFloat = 0
    var SCREEN_WIDTH: CGFloat = 0
    
    //Constants using binary shift for collision detection
    public static let NO_CATEGORY:UInt32 = 0b1 << 1
    public static let PLAYER_CATEGORY:UInt32 = 0b1 << 2
    public static let ENEMY_CATEGORY:UInt32 = 0b1 << 3
    
    //Variable to hold score
    var score = 0
    //Label to output score
    var scoreLabel = SKLabelNode()
    //Variable to hold number of coins
    var coins = 0
    //Label to output number of coins
    var coinLabel = SKLabelNode()
    //Variable to hold the current wave of monsters
    var wave = 0
    //Label to output the wave
    var waveLabel: SKLabelNode?
    
    //Variables to hold saved data
    var isLoaded = false
    var savedState = GameState(towerHealth: 1000, wave: 0, score: 0, coins: 0, monsters: [], outposts: [nil, nil, nil, nil], castle: nil)
    
    //Variable that holds which button in a menu was clicked
    var clicked: Base?
    var positionClicked: CGPoint?
    var buttonClicked: SKButtonNode?
    
    /* Data relating to Outpost Modification */
    
    //Outposts active
    var outposts: [Outpost?] = [nil, nil, nil, nil]
    //Places where outposts can be placed
    var outpostRanges: [SKShapeNode] = [SKShapeNode(circleOfRadius: 45), SKShapeNode(circleOfRadius: 45), SKShapeNode(circleOfRadius: 45), SKShapeNode(circleOfRadius: 45)]
    //Which places already hold an outpost
    var taken = [false, false, false, false]
    //Positions of outpost locations
    let positions: [CGPoint] = [CGPoint(x:250,y:0), CGPoint(x:-250,y:0), CGPoint(x:0,y:200), CGPoint(x:0,y:-200)]
    
    //Variable to hold only 1 menu at a time
    var menu: Menu?
    
    //Button to popup options for new outposts
    let addButton = SKButtonNode(normalTexture: SKTexture(imageNamed: "button_add-outpost"), selectedTexture: SKTexture(imageNamed: "clicked_add"), disabledTexture: nil)
    //Button to popup options for adding upgrades
    let upgradeButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button_upgrade-tower")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_upgrade-1")), disabledTexture: nil)
    //Button to popup options for removing outposts
    let removeButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button_remove-outpost")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_remove")), disabledTexture: nil)
    //Button to popup options for sending in a meteor
    let meteorButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "button-1")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "clicked_meteor")), disabledTexture: nil)
    //Timer used to determine cooldown for meteor
    let meteorTimer = CountDownTimer(damage: 150)
    //Button to popup options for bringing up the pause menu
    let pauseButton = SKButtonNode(normalTexture: SKTexture(image: #imageLiteral(resourceName: "pause")), selectedTexture: SKTexture(image: #imageLiteral(resourceName: "pause")), disabledTexture: nil)
    
    /* Data relating to enemies */
    
    //List of active enemies
    var enemies: [Monster] = []
    //List of enemies created in the wave
    var enemiesCreated: [Monster] = []
    
    //Object to represent main base
    var castle: Castle?
    //Holds state of game
    var isPlaying = false
    //Possible types of monsters
    let types: [MonsterAttributes] = [MonsterAttributes(imageNamed: "zombie", attackDmg: 10, runSpeed: 5, attackDelay: 2, health: 50, resistance: .None()), MonsterAttributes(imageNamed: "tank_none", attackDmg: 30, runSpeed: 10, attackDelay: 2, health: 150, resistance: .None()), MonsterAttributes(imageNamed: "runner_none", attackDmg: 15, runSpeed: 2, attackDelay: 2, health: 30, resistance: .None()), MonsterAttributes(imageNamed: "zombie", attackDmg: 10, runSpeed: 5, attackDelay: 2, health: 50, resistance: .Fire()), MonsterAttributes(imageNamed: "tank_fire", attackDmg: 30, runSpeed: 10, attackDelay: 2, health: 150, resistance: .Fire()), MonsterAttributes(imageNamed: "runner_fire", attackDmg: 15, runSpeed: 2, attackDelay: 2, health: 30, resistance: .Fire()), MonsterAttributes(imageNamed: "zombie", attackDmg: 10, runSpeed: 5, attackDelay: 2, health: 50, resistance: .Ice()), MonsterAttributes(imageNamed: "tank_ice", attackDmg: 30, runSpeed: 10, attackDelay: 2, health: 150, resistance: .Ice()), MonsterAttributes(imageNamed: "runner_ice", attackDmg: 15, runSpeed: 2, attackDelay: 2, health: 30, resistance: .Ice())]
    
    
    //////////////////////////
    /*     Scene Lifecycle Functions    */
    //////////////////////////
    
    
    /*  Function once in lifetime when scene loads */
    override func sceneDidLoad() {
        //Set the medium for collison detection
        physicsWorld.contactDelegate = self
        SCREEN_HEIGHT = frame.height / 2
        SCREEN_WIDTH = frame.width / 2
        //Preload the sound effects to reduce lag
        preloadSounds()
        
        //Initialize the outpost ranges
        for i in 0...outpostRanges.count-1 {
            outpostRanges[i].position = positions[i]
            addChild(outpostRanges[i])
        }
        
        //Initialize the add button
        initButton(addButton)
        //Initialize the upgrade button
        initButton(upgradeButton)
        //Initialize the remove button
        initButton(removeButton)
        //Initialize the meteor button
        initButton(meteorButton)
        //Initialize the pause button
        initButton(pauseButton)
        
        //Initialize Labels
        spawnInfoLabel(coinLabel)
        spawnInfoLabel(scoreLabel)
        
        //Create lines
        spawnVisualPath()
        
        //Show the starting label
        spawnWaveTitle()
        
        }
    
    /* Function called when view is brought into view */
    override func didMove(to view: SKView) {
        //Load state from save
        loadState()
        //Initialize the main base
        spawnCastle()
    }
    
    /* Function called when a touch is detected on scene */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* CHeck if game is first starting */
        if wave == 0 || isLoaded {
            
            waveLabel?.removeFromParent()
            waveLabel = nil
            
            if isLoaded {
                //Initlialize enemies
                for i in 0..<enemiesCreated.count {
                    let enemy = enemiesCreated[i]
                    if enemy.health <= 0 {
                        //dead.append(i)
                        enemies.removeLast()
                        continue
                    }
                    enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.frame.height / 2)
                    //Moves around
                    enemy.physicsBody?.isDynamic = true
                    //No gravity
                    enemy.physicsBody?.affectedByGravity = false
                    //Set collision bitmasks (who to collide with)
                    //Enemy category
                    enemy.physicsBody?.categoryBitMask = GameScene.ENEMY_CATEGORY
                    //Who to record collision with
                    enemy.physicsBody?.contactTestBitMask = GameScene.PLAYER_CATEGORY
                    //Who to visibily recoil with
                    enemy.physicsBody?.collisionBitMask = GameScene.PLAYER_CATEGORY
                    enemy.removeFromParent()
                    addChild(enemy)
                    enemy.label.removeFromParent()
                    addChild(enemy.label)
                    //Load enemies
                    //enemiesCreated.append(enemy)
                    //enemies.append(enemy)
                    enemy.isPaused = false
                    guard let action = enemy.actions else {
                        continue
                    }
                    enemy.run(action)
                }
                //Stop loading
                isLoaded = false
            }
            
            //Start game
            isPlaying = true
        }
        
        //If game isnt playing, do nothing
        if !isPlaying {
            return
        }
        
        //Spawn new wave of monters
        //if no more are present
        spawnNewWave()
        //Remove menu based on touch location
        dismissMenu(touches)
        //Add or upgrade outpost based on touch location
        onRangeClick(touches)
        //Remove outpost based on touch location
        dismissRemove(touches)
        //Launch a meteor if selected
        sendMeteor(touches)
        
        }
    
    
    /* Function that is called every time a frame is rendered */
    override func update(_ currentTime: TimeInterval) {
        //If game isnt playing, do nothing
        if !isPlaying { return }
        
        //Set current instace of game in GameViewController
        GameViewController.scene = self
        
        /* Loop through all enemies */
        var i = 0
        while i < enemiesCreated.count {
            //Check if the enemy isnt dead
            if enemiesCreated[i].parent == nil {
                //Move to next loop
                i += 1
                continue
            }
            
            //Launch and attack from casstle if enemy is in range
            castle?.decideAttack(enemy: enemiesCreated[i])
            //Update enemies health label
            enemiesCreated[i].updateLabel()
            //Update castle health label
            castle?.updateLabel()
            
            /* If the enemy is dead, animate death */
            if enemiesCreated[i].health <= 0 {
                animateMonsterDeath(i: i)
                break
            }
            
            if enemiesCreated[i].position == CGPoint(x: 0, y: 0) {
                guard let collision = enemiesCreated[i].collisionPoint else{
                    i += 1
                    continue
                }
                enemiesCreated[i].position = collision
            }
            
            /* Iterate through all outposts */
            var j = 0
            while j < outposts.count{
                //Check if the base has been created
                if outposts[j] == nil {
                    //Continue to next iteration
                    j += 1
                    continue
                    
                }
                //Create attack if enemy is in range
                outposts[j]!.decideAttack(enemy: enemiesCreated[i])
                j += 1
                }
            
            //Update monster action
            if let actions = enemiesCreated[i].action(forKey: Monster.ACTION_KEY) {
                enemiesCreated[i].actions = actions
            }
            
            //Update score and coin labels
            coinLabel.text = "Coins: \(coins)"
            scoreLabel.text = "Score: \(score)"
            i += 1
        }
        
        /* If the castle is dead, end game */
        if (castle?.health)! <= 0 {
            //Remove from screen
            castle?.removeFromParent()
            //Remove label from screen
            castle?.label.removeFromParent()
            //Store score in leaderboard and system alert
            endGame()
            //Stop game
            isPlaying = false
        }
        
        /* If the meteor timer is still running keep button disabled */
        if meteorTimer.isAttacking {
            //Show current time left
            meteorButton.label.text = "\(Int(meteorTimer.secondsLeft)) sec Left"
        }else {
            //Timer is ended, resume functionality
            meteorButton.label.text = "Launch Meteor"
        }
        
        /* If enemies are all destroyed, bring up a game label */
        if enemies.isEmpty && waveLabel == nil {
            //Create label
            spawnWaveTitle()
        }
        
    }
    
    
    //////////////////////////
    /*     Functions that handle Collisions    */
    //////////////////////////
    
    
    /* Function that is called when when ther is a collision between 2 children with bitmasks */
    func didBegin(_ contact: SKPhysicsContact) {
        //Collect two collided bodies
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        /* Based on which object is the castle, decrease damage to castle body */
        if nodeA?.name == "tower" {
            //Downcast object to monster
            let enemy = nodeB as! Monster
            //Remove all actions
            enemy.removeAllActions()
            enemy.actions = nil
            //Store collision point
            enemy.collisionPoint = enemy.position
            //Start dealing damage
            collisionBetween(tower: nodeA as! Castle, enemy: enemy)
        } else if nodeB?.name == "tower" {
            //Downcast object to monster
            let enemy = nodeA as! Monster
            //Remove all actions
            enemy.removeAllActions()
            enemy.actions = nil
            //Store collision point
            enemy.collisionPoint = enemy.position
            //Start dealing damage
            collisionBetween(tower: nodeB as! Castle, enemy: enemy)
        }
        
    }
    
    /* Function that handles a collision with zombies and main base */
    func collisionBetween(tower: Castle, enemy: Monster) {
        //Variable to store whether enemy is still dealing damage
        enemy.isAttacking = true
        /* Create new thread decreases castle health at a certain interva' */
        DispatchQueue.global(qos: .background).async {
            while(enemy.isAttacking){
                //Check if it is alive
                if enemy.parent == nil {
                    //End
                    enemy.isAttacking = false
                    return
                }
                //Decrease damage
                tower.health -= enemy.attackDmg
                //Wait
                Thread.sleep(forTimeInterval: TimeInterval(enemy.attackDelay))
            }
        }
    }
    
    //////////////////////////
    /*     Functions called for initlizations    */
    //////////////////////////
    
    /* Function that prepares sound effects */
    func preloadSounds(){
        //Array of sounds
        let sounds: [String] = ["meteor_crash", "oof", "building_sound"]
        //Catch exceptions thrown
        do {
            //Iterate thriugh array
            for sound in sounds {
                var fileExtension = ""
                //Determine extension based on name
                if sound == "meteor_crash" || sound == "building_sound" {
                    fileExtension = "mp3"
                }else if sound == "oof" {
                    fileExtension = "wav"
                }
                //Retrieve location
                let path:String = Bundle.main.path(forResource: sound, ofType: fileExtension)!
                //Create URL
                let url: URL = URL(fileURLWithPath: path)
                //Make AVAudioPlayer object
                let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                //Prepare for use
                player.prepareToPlay()
            }
            //Catch  block
        } catch {}
        
    }
    
    /* Function that loads save file */
    func loadState(){
        if !isLoaded {return}
        if let castle = savedState.castle {
            self.castle = Castle(self, imageNamed: "castle_asset", attacks: castle.attacks)
            self.castle?.rangedDmg = castle.rangedDmg
            self.castle?.meleeDmg = castle.meleeDmg
            self.castle?.rangeUpgradeCost = castle.rangeUpgradeCost
            self.castle?.cooldownUpgradeCost = castle.cooldownUpgradeCost
            self.castle?.damageOutoutUpgradeCost = castle.damageOutoutUpgradeCost
            self.castle?.rangeUpgradeCount = castle.rangeUpgradeCount
            self.castle?.cooldownUpgradeCount = castle.cooldownUpgradeCount
            self.castle!.spawn()
        }
        //Load health
        if savedState.towerHealth == 0 {
            castle?.health = 1000
        } else {
            castle?.health = savedState.towerHealth
        }
        //Load coins
        coins = savedState.coins
        //Load score
        score = savedState.score
        //Load wave
        wave = savedState.wave
        //Load enemies
        enemiesCreated = savedState.monsters
        enemies = savedState.monsters
        //Load outposts
        outposts = savedState.outposts
        //Initialize outposts
        for outpost in outposts {
            if outpost == nil {continue}
            outpost!.removeFromParent()
            addChild(outpost!)
        }
        
    }
    
    /* Function that sets properties of score and coin labels */
    func spawnInfoLabel(_ label: SKLabelNode){
        //Choose based on parameter
        if label == coinLabel {
            //Retrieve from file
            coinLabel = childNode(withName: "coinLabel") as! SKLabelNode
            //Set proper position
            coinLabel.position = CGPoint(x: -300, y: -SCREEN_HEIGHT + 30)
            //Set proper text
            coinLabel.text = "Coins: \(coins)"
        }else if label == scoreLabel {
            //Retrieve from file
            scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
            //Set proper position
            scoreLabel.position = CGPoint(x: 300, y: -SCREEN_HEIGHT + 30)
            //Set proper text
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    /* Function that creates popup at each round */
    func spawnWaveTitle(){
        //Create label
        let label = SKLabelNode(text: "Click to Start Wave \(wave + 1)")
        
        //Check if the game has started
        if wave == 0 {
            label.text = "Click to Start Game"
        }
        //Assign respective properties
        label.position = CGPoint.zero
        label.zPosition = 250
        label.fontSize = 100
        label.fontColor = UIColor.white
        label.name = "label"
        //Add to scene
        addChild(label)
        //Assign to instance
        waveLabel = label
        
        //Reset meteor timer
        meteorTimer.originalTime = 60
        meteorTimer.secondsLeft = 60
        meteorTimer.isAttacking = false
        meteorTimer.timer.invalidate()
        meteorButton.label.text = "Launch Meteor"
    }
    
    
    /* Function that creates and adds enemies to scene */
    func spawnMonster() {
        //Create progressively more enemies
        let numEnemiesSpawn = 5 + 3*(wave-1)
        
        //Spawn x amount of enemies
        for _ in 0...numEnemiesSpawn {
            //Set variety of monster based on wave
            var range = types.count
            if wave < 2 {
                range = 1
            }else if wave <= 3 {
                range = 3
            }
            
            //Generate random number
            let rand = Int(arc4random_uniform(UInt32(range)))
            //Create copy instance
            var copyAttribute = types[rand]
            //Add increasingly difficulty to attack damage
            copyAttribute.attackDmg += wave
            //Add increasing health
            copyAttribute.health *= ((wave+4) / 4)
            //Create new monster
            let monster = Monster(imageNamed: types[rand].imageNamed, inScene: self, attributes: copyAttribute)
            //Store in variable
            enemies.append(monster)
            enemiesCreated.append(monster)
            //Spawn
            monster.spawn()
        }

    }
    
    /* Function that creates and adds the main base to scene */
    func spawnCastle(){
        //Init castle
        if castle == nil {
        castle = Castle(self, imageNamed: "castle_asset", attacks: [DamageTypes.Melee(), DamageTypes.Ranged()])
        //Spawn castle
        castle?.spawn()
        }
    }
    
    /* Function that creates and adds an outpost to scene */
    func spawnOutpost(touchP: CGPoint, imageNamed: String, attacks: [DamageTypes]){
        //Iterate through outposts
        for i in 0...outpostRanges.count-1 {
            //Check if touch is inside range and not taken by an outpost
            if outpostRanges[i].contains(touchP) && !taken[i] {
                //Indicate the position is no longer available
                taken[i] = true
                //Create new outpost
                let outpost = Outpost(self, imageNamed: imageNamed, attacks: attacks)
                //Set outpost in touch location
                outpost.position = touchP
                //Set outpost size
                outpost.size = CGSize(width: 100, height: 100)
                //Set zposition
                outpost.zPosition = 1
                //Create ranges for enemy detection
                outpost.createRanges()
                //Add to list
                outposts[i] = outpost
                //Add in scene
                addChild(outpost)
                break
            }
        }
        
    }
    
    /* Function that initializes values for buttons */
    func initButton(_ button : SKButtonNode){
        //Set zPosition
        button.zPosition = 1000
        //Set size
        button.size = CGSize(width: CGFloat(250), height: CGFloat(50))
        
        //Choose different properties based on parameter
        if button == addButton {
            //Set position
            button.position = CGPoint(x: -SCREEN_WIDTH + 130,y: SCREEN_HEIGHT - 30)
            //Assign action
            button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.addAction))
        }else if button == upgradeButton {
            //Set position
            button.position = CGPoint(x: -SCREEN_WIDTH + 400,y: SCREEN_HEIGHT - 30)
            //Assign action
            button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.upgradeAction))
        }else if button == removeButton {
            //Set position
            button.position = CGPoint(x: 0,y: SCREEN_HEIGHT - 30)
            //Assign action
            button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.removeOutpostAction))
        }else if button == meteorButton {
            //Set position
            button.position = CGPoint(x: 275,y: SCREEN_HEIGHT - 30)
            //Assign action
            button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.meteorAction))
            //Set label
            button.setButtonLabel(title: "Launch Meteor", font: "Helvetica", fontSize: 25)
            //Set text colour
            button.label.fontColor = UIColor.white
        }else if button == pauseButton {
            //Set size
            button.size = CGSize(width: CGFloat(75), height: CGFloat(75))
            //Set position
            button.position = CGPoint(x: SCREEN_WIDTH - 130,y: SCREEN_HEIGHT - 50)
            //Assign action
            button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.pauseAction))
        }
        //Add button to scene
        addChild(button)
    }
    
    /* Function that adds a visual path for monsters to travel */
    func spawnVisualPath() {
        var pointLeftUp = [
            CGPoint(x: size.width/2 + 130, y: 0),
            CGPoint(x: 350, y: 0),
            CGPoint(x: 250, y: 150),
            CGPoint(x: 175, y: 150),
            CGPoint(x: 0, y: 0)]
        var pointLeftDown = [
            CGPoint(x: 350, y: 0),
            CGPoint(x: 250, y: -150),
            CGPoint(x: 175, y: -150),
            CGPoint(x: 0, y: 0)]
        
        var pointRightUp = [
            CGPoint(x: -size.width/2 - 130, y: 0),
            CGPoint(x: -350, y: 0),
            CGPoint(x: -250, y: 150),
            CGPoint(x: -175, y: 150),
            CGPoint(x: 0, y: 0)]
        var pointRightDown = [
            CGPoint(x: -350, y: 0),
            CGPoint(x: -250, y: -150),
            CGPoint(x: -175, y: -150),
            CGPoint(x: 0, y: 0)]
        
        let PATH_COLOUR = UIColor(red: 165/255, green: 90/255, blue: 50/255, alpha: 0.9)
        
        let lineLeftUp = SKShapeNode(points: &pointLeftUp, count: pointLeftUp.count)
        lineLeftUp.strokeColor = PATH_COLOUR
        lineLeftUp.lineWidth = 25
        lineLeftUp.zPosition = 2
        addChild(lineLeftUp)
        let lineLeftDown = SKShapeNode(points: &pointLeftDown, count: pointLeftDown.count)
        lineLeftDown.strokeColor = PATH_COLOUR
        lineLeftDown.lineWidth = 25
        lineLeftDown.zPosition = 2
        addChild(lineLeftDown)
        
        let lineRightUp = SKShapeNode(points: &pointRightUp, count: pointRightUp.count)
        lineRightUp.strokeColor = PATH_COLOUR
        lineRightUp.lineWidth = 25
        lineRightUp.zPosition = 2
        addChild(lineRightUp)
        let lineRightDown = SKShapeNode(points: &pointRightDown, count: pointRightDown.count)
        lineRightDown.strokeColor = PATH_COLOUR
        lineRightDown.lineWidth = 25
        lineRightDown.zPosition = 2
        addChild(lineRightDown)
    }
    
    /* Function that handles spawning of new wave */
    func spawnNewWave(){
        if enemies.isEmpty {
            enemiesCreated.removeAll()
            wave += 1
            spawnMonster()
            
            waveLabel?.removeFromParent()
            waveLabel = nil
            
            var left = [Monster]()
            var right = [Monster]()
            
            for enemy in enemiesCreated {
                if enemy.position.x > 0 {
                    right.append(enemy)
                }else {
                    left.append(enemy)
                }
            }
            
            moveMonsters(monsters: left, counter: 0)
            moveMonsters(monsters: right, counter: 0)
            
            
        }
    }
    
    
    //////////////////////////
    /*     Functions that handle interaction with Charcters and User    */
    //////////////////////////
    
    
    /* Function recursively that animates the monsters to move one by one in a certain path */
    func moveMonsters(monsters: [Monster], counter: Int){
        //Break condition
        if counter >= monsters.count {
            return
        }
        
        //Check if enemy is dead
        if monsters[counter].parent == nil {
            //Continue
            self.moveMonsters(monsters: monsters, counter: counter + 1)
        }else {
            //Create delay dtermined by monster runspeed
            let delayInSeconds = Double(monsters[counter].runSpeed / 2)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            //Flip counter element in array
            monsters[counter].moveToCenter()
            //Start recursion with updated incremented counter
            self.moveMonsters(monsters: monsters, counter: counter + 1)
        }
        }
    }
 
    /* Function that handles when outpost range is clicked */
    func onRangeClick(_ touches: Set<UITouch>) {
        //Check button clicked
        if buttonClicked == nil {
            return
        }
        
        //Iterate through outpost ranges
        var i = 0
        OuterLoop: while i < outpostRanges.count{
            //Iterate through touches
            for touch in touches {
                //If outpost range is tapped
                if outpostRanges[i].contains(touch.location(in: self)) {
                    //Quit loop
                    break OuterLoop
                    //If castle is tapped
                }else if castle!.contains(touch.location(in: self)) {
                    //If upgrade is selected
                    if buttonClicked == upgradeButton {
                        //Assign castle to saved member
                        clicked = castle!
                        //Create popup menu
                        popUpMenu(upgradeButton)
                    }
                    //Quit
                    return
                }
            }
            i += 1
        }
        
        //If loop was fully iterated through
        if i == outpostRanges.count {
            //Quit
            return
        }
        
        //If button clicked was add
        if buttonClicked == addButton {
            //Store position
            positionClicked = outpostRanges[i].position
            popUpMenu(addButton)
        //If button clicked was upgrade
        }else if buttonClicked == upgradeButton {
            if outposts[i] == nil {return}
            clicked = outposts[i]
            popUpMenu(upgradeButton)
        //If button clicked was remove
        }else if buttonClicked == removeButton {
            if taken[i] {
            //Remove sprite from scene
            outposts[i]?.removeFromParent()
            //Dealloc outpost
            outposts[i] = nil
            //Open spot
            taken[i] = false
            //Add coins
            coins += 50
            }
        }
    }

    /* Function that determines whether to send a meteor */
    func sendMeteor(_ touches: Set<UITouch>){
        //If button clicked is meteor button
        if buttonClicked == meteorButton && !meteorTimer.isAttacking {
            //Stop additional meteors from spawning
            meteorTimer.isAttacking = true
            //Reassign time
            meteorTimer.originalTime = 60
            meteorTimer.secondsLeft = 60
            //Create new circle around tap location
            let path = CGMutablePath()
            path.addArc(center: touches.first!.location(in: self),
                            radius: 125,
                            startAngle: 0,
                            endAngle: CGFloat.pi * 2,
                            clockwise: true)
            let AoE = SKShapeNode(path: path)
            
            //Animate meteor impact
            animateMeteor(touches)
            
            /* Delay until meteor crashes */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.7) {
                //Iterate through monsters
                for enemy in self.enemiesCreated {
                    //Check if its alive
                    if enemy.parent == nil {
                        continue
                    }
                    //Check if range contains any enemies
                    if AoE.contains(enemy.position) {
                        //Deal damage to enemy
                        enemy.health -= self.meteorTimer.damage
                    }
                }
                //Start timer
                self.meteorTimer.startTimer()
                //Close menu if open, reset members
                self.closeMenu()
            }
        }
    }
    
    ///////////////////
    /* A set of functions to animate events */
    //////////////////
    
    /* Animate meteor crashing */
    func animateMeteor(_ touches: Set<UITouch>){
        //Create meteor object
        let meteor = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "star")))
        //Set position
        meteor.position = CGPoint(x:0, y: SCREEN_HEIGHT + 100 )
        meteor.zPosition = 3
        //Set size
        meteor.size = CGSize(width: 50, height: 50)
        //Add to scene
        addChild(meteor)
        //Rotate while in air
        meteor.run(SKAction.repeatForever(SKAction.rotate(byAngle: 360, duration: 3)))
        //Move to touch location
        meteor.run(SKAction.move(to: touches.first!.location(in: self), duration: 1.5))
 
        /* After crash, add fire effect */
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
            //Create fire effect
            let fireEffect = SKEmitterNode(fileNamed: "MeteorAfterEffect")
            //Set position
            fireEffect?.position = touches.first!.location(in: self)
            //Set target
            fireEffect?.targetNode = self
            //Add to scene
            self.addChild(fireEffect!)
            //Play sound effect
            self.run(SKAction.playSoundFileNamed("meteor_crash", waitForCompletion: false))
            /* Wait quater of a second */
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                //Remove sprites
                fireEffect?.removeFromParent()
                meteor.removeFromParent()
            }
        }
    }
    
    /* Function that animates when a monster's health reaches 0 */
    func animateMonsterDeath(i: Int){
        //Remove enemy
        enemies.removeLast()
        //Create emitter
        let emitter = SKEmitterNode(fileNamed: "BloodSplater")
        //Set position to enemy death site
        emitter?.position = enemiesCreated[i].position
        //Set taget
        emitter?.targetNode = self;
        //Add to scene
        addChild(emitter!)
        //Play sound effect
        run(SKAction.playSoundFileNamed("oof", waitForCompletion: false))
        //Wait fifth of a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //Remove effect from scene
            emitter?.removeFromParent()
        }
        //Store and remove dead monster
        let removed = self.enemiesCreated[i]
        //Remove sprite from scene
        removed.removeFromParent()
        //Remove health label from scene
        removed.label.removeFromParent()
        //Increment score and coins
        self.score += 10
        self.coins += 10
    }
    
    ///////////////////
    /* Set of functions that manage the menu */
    /////////////

    /* Function that close menu if present and resets members */
    func closeMenu(){
        //Remove from scene
        menu?.close()
        //Dealloc
        menu = nil
        //Iterate through outposts
        for range in outpostRanges {
            //Hide ranges
            range.isHidden = true
        }
        //Set members to nil
        clicked = nil
        buttonClicked = nil
        positionClicked = nil
    }
    
    /* Function that creates menu */
    func popUpMenu(_ type: SKButtonNode){
        //Create menu
        menu = Menu(scene: self, type)
        //Add to scene
        addChild(menu!)
    }
    
    /* Function that determines when to close menu */
    func dismissMenu(_ touches: Set<UITouch>) {
        //Check if it is present
        if menu != nil {
            //Iterate through touches
            for touch in touches {
                //If touch position is not in menu
                if !menu!.contains(touch.location(in: self)) {
                    //remove menu
                    closeMenu()
                }
            }
        }
    }
    
    /* Function that determines when to remove ranges from remove button */
    func dismissRemove(_ touches: Set<UITouch>){
        //Condition
        let add = buttonClicked == addButton && menu == nil
        //Alternate condition
        let upgrade = buttonClicked == upgradeButton && menu == nil
        //Check either condition
        if buttonClicked == removeButton || add || upgrade {
            //Iterate through outposts
            for outpost in outpostRanges {
                //Iterate through touches
                for touch in touches {
                    //If outpost contains touch position
                    if !outpost.contains(touch.location(in: self)) {
                        //Close menu
                        closeMenu()
                    }
                }
            }
        }
    }
    
    
    
    /////////////////////////
    /* Set of Functions that define what is executed when buttons are clicked */
    ////////////////////////
    
    /* Action ran when add button clicked */
    @objc func addAction(){
        //Store decision
        buttonClicked = addButton
        //Close menu if present
        if menu != nil {
            menu?.close()
        }
        //Iterate through outposts ranges
        for range in outpostRanges {
            //Set to green
            range.isHidden = false
            range.zPosition = 1
            range.fillColor = .green
            range.alpha = 0.5
        }
        
    }
    
    /* Action ran when upgrade button clicked */
    @objc func upgradeAction(){
        //Store decision
        buttonClicked = upgradeButton
        //Close menu if present
        if menu != nil {
            menu?.close()
        }
        //Iterate through outposts ranges
        for range in outpostRanges {
            //Set to blue
            range.isHidden = false
            range.fillColor = .blue
        }
    }
    
    /* Action ran when remove button clicked */
    @objc func removeOutpostAction(){
        //Store decision
        buttonClicked = removeButton
        //Close menu if present
        if menu != nil {
            menu?.close()
        }
        //Iterate through outposts ranges
        for range in outpostRanges {
            //Set ranges to red
            range.isHidden = false
            range.fillColor = .red
        }
        
    }
    
    /* Action ran when meteor button clicked */
    @objc func meteorAction(){
        //If timer has not ended
        if meteorTimer.isAttacking {
            //Exit
            return
        }
        //Store decision
        buttonClicked = meteorButton
        //Close menu if present
        if menu != nil {
            menu?.close()
        }
    }
    
    /* Action ran when pause button clicked */
    @objc func pauseAction(){
        //Create menu
        let pauseMenu = PauseMenu(scene: self, wave: wave)
        //Add to scene
        addChild(pauseMenu)
        //End game
        isPlaying = false
        //Iterate through monsters
        for enemy in enemiesCreated {
            //Check if alive
            if enemy.parent == nil {
                continue
            }
            //Pause enemy
            enemy.isPaused = true
            
        }
        
    }
    
    
    //////////////////////////
    /*     Function called when game is done   */
    //////////////////////////
    func endGame(){
        //Create alert
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        //Add textfield
        alert.addTextField(configurationHandler: { textField in
            //Placeholder text
            textField.placeholder = "Enter your Name"
        })
        
        //Action when 'ok' button is clicked
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //Check if textfield has text
            if let name = alert.textFields?.first?.text {
                //Store score and names
                LeaderboardViewController.storeHighScore(score: self.score, name: name, keyScore: LeaderboardViewController.SCORE_KEY, keyName: LeaderboardViewController.NAME_KEY)
                //Exit from viewcontroller (Back to home screen)
                self.viewController!.dismiss(animated: true)
            }
        }))
        
        //Create new empty save
        MainViewController.savedState = GameState(towerHealth: 1000, wave: 0, score: 0, coins: 0, monsters: [], outposts: [nil, nil, nil, nil], castle: nil)
        //Save state
        MainViewController.save()
        //Show alert
        viewController!.present(alert, animated: true)
    }
    
    
}
