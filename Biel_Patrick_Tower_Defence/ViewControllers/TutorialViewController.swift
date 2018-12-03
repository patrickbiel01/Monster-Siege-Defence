//
//  TutorialViewController.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var tutorialTitle: UILabel!

    @IBOutlet weak var step1: UILabel!
    @IBOutlet weak var step2: UILabel!
    @IBOutlet weak var step3: UILabel!
    
    @IBOutlet weak var description1: UILabel!
    @IBOutlet weak var description2: UILabel!
    @IBOutlet weak var description3: UILabel!
    
    var sent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupViews(){
        switch sent {
        case 1:
            tutorialTitle.text = "How to Add Towers"
            description1.text = "Click the Add Outpost Button"
            description2.text = "Click on the green circle where the new outpost should be placed"
            description3.text = "Click the button in the popup menu for the type of tower to be added"
        case 2:
            tutorialTitle.text = "How to Upgrade Towers"
            description1.text = "Click the Upgrade Outpost Button"
            description2.text = "Click on the tower to be upgraded"
            description3.text = "Click on the button in the popup menu for the type of upgrade to be applied"
        case 3:
            tutorialTitle.text = "How to Remove Towers"
            description1.text = "Click the Remove Outpost Button"
            description2.text = "Click on the outpost to be deleted"
            step3.isHidden = true
            description3.isHidden = true
        case 4:
            tutorialTitle.text = "How to Launch Meteors"
            description1.text = "Click the Launch Meteor Button"
            description2.text = "Click on the screen where the meteor should be placed"
            step3.isHidden = true
            description3.isHidden = true
        default:
            tutorialTitle.text = "Error"
        }
    }
    
    
}
