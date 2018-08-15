//
//  CountDownTimer.swift
//  Biel_Patrick_Tower_Defence
//
//  Created by Period Three on 2018-05-17.
//  Copyright © 2018 Period Three. All rights reserved.
//

import Foundation

/* Class that dtermines when an actor deals damage */
class CountDownTimer: NSObject, NSCoding {
    //Original TIme
    var originalTime = 2.0
    //Timer object
    var timer = Timer()
    //Seconds left tracker
    var secondsLeft = 2.0
    //State
    var isAttacking = false
    //Damage dealt
    var damage: Int
    
    /* Base Init */
    init(damage: Int) {
        //Assign damage
        self.damage = damage
    }
    
    /* Init for decoding */
    required init?(coder aDecoder: NSCoder) {
        //DEcode secondsleft
        secondsLeft = Double(aDecoder.decodeDouble(forKey: "secondsLeft"))
        //DEcode original time
        originalTime = aDecoder.decodeDouble(forKey: "originalTime")
        //DEcode damage
        damage = aDecoder.decodeInteger(forKey: "damage")
        //Decode state
        isAttacking = aDecoder.decodeBool(forKey: "isAttacking")
    }
    
    /* Function that encodes data */
    func encode(with aCoder: NSCoder) {
        //Encode seconds left
        aCoder.encode(secondsLeft, forKey: "secondsLeft")
        //Encode orginal time
        aCoder.encode(originalTime, forKey: "originalTime")
        //Encode state
        aCoder.encode(isAttacking, forKey: "isAttacking")
        //Encode damage
        aCoder.encode(damage, forKey: "damage")
    }
    
    /* Initilaize timer object */
    func startTimer(){
        isAttacking = true
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self,   selector: #selector(CountDownTimer.updateTimer), userInfo: nil, repeats: true)
        secondsLeft = originalTime
    }
    
    /* Function run at every time interval */
    @objc func updateTimer() {
        //Subtract time
        secondsLeft -= 0.3
        
        //Break case
        if secondsLeft <= 0 {
            //Reset timer
            resetTimer()
        }
        
    }
    
    /* Function that resets the timer */
    func resetTimer(){
        //End
        timer.invalidate()
        //Reset time
        secondsLeft = originalTime
        //Set state
        isAttacking = false
    }
    
}
