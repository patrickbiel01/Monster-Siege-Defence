//
//  RulesViewController.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit

//Class to control the Rules View
class RulesViewController: UIViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var meteorBtn: UIButton!
    
    /* Function called when back button is clicked */
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMechanicClick(_ sender: UIButton) {
        performSegue(withIdentifier: "tutorial", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialViewController = segue.destination as? TutorialViewController {
            guard let button = sender as? UIButton else {
                return
            }
            
            switch button {
            case addBtn:
                tutorialViewController.sent = 1
            case upgradeBtn:
                tutorialViewController.sent = 2
            case removeBtn:
                tutorialViewController.sent = 3
            case meteorBtn:
                tutorialViewController.sent = 4
            default:
                tutorialViewController.sent = 0
            }
            
        }
    }
}
