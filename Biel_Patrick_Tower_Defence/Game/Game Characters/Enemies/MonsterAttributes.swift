//
//  MonsterAttributes.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
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
