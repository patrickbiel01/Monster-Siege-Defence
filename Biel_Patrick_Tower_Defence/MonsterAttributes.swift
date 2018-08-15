//
//  MonsterAttributes.swift
//  Biel_Patrick_Tower_Defence
//
//  Created by Period Three on 2018-05-14.
//  Copyright © 2018 Period Three. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/* Properties that define a monster */
struct MonsterAttributes {
    let imageNamed: String
    var attackDmg: Int
    let runSpeed: Int
    let attackDelay: Int
    var health: Int
    let resistance: DamageTypes
}
