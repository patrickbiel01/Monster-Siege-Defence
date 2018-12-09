//
//  LeaderboardViewController.swift
//  Monster Siege Defence
//
//  Created by Patrick Biel on 2018-05-11.
//  Copyright © 2018 Patrick Biel. All rights reserved.
//

import UIKit

//Class that controls display of the leaderboard
class LeaderboardViewController: UIViewController, UITableViewDataSource {
    //Tableview object
    @IBOutlet weak var tableView: UITableView!
    //Key for names
    public static let NAME_KEY = "namekey"
    //Key for scores
    public static let SCORE_KEY = "scorekey"
    
    //Arrays to store highscores
    private var highScoreNames: [String] = []
    private var highScoreValues: [Int] = []
    
    /* Function that runs when view is aboutto appear */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Retrieve object for persient data
        let userDefaults = UserDefaults.standard
        
        // Clear UserDefaults: USED FOR TESTING
        //        let domain = Bundle.main.bundleIdentifier!
        //        UserDefaults.standard.removePersistentDomain(forName: domain)
        //        UserDefaults.standard.synchronize()
        
        //Retrieve high scores
        guard let highScoreNames = userDefaults.object(forKey: LeaderboardViewController.NAME_KEY) as? Array<String> else {
            self.highScoreNames = ["Empty","Empty","Empty","Empty","Empty","Empty"]
            self.highScoreValues = [0,0,0,0,0,0]
            return
        }
        //Retrieve high score names
        guard let highScoreValues = userDefaults.object(forKey: LeaderboardViewController.SCORE_KEY) as? Array<Int> else {
            self.highScoreNames = ["Empty"]
            self.highScoreValues = [0]
            return
        }
        
        //Assign retrieved values to member arrays
        self.highScoreNames = highScoreNames
        self.highScoreValues = highScoreValues
    }
    
    /* Function called when Table View is loaded */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Create n cells
        return highScoreValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create new cell
        let myCell = UITableViewCell()
        
        /* Set styles for tableview */
        //Background
        tableView.backgroundColor = .clear
        myCell.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        //Text colour
        myCell.textLabel!.textColor = .white
        
        //Set text
        myCell.textLabel?.text = "\(indexPath.row + 1). \t\t" + highScoreNames[indexPath.row] + ": " + String(highScoreValues[indexPath.row])
        
        //Apply cell
        return myCell
    }

    /* Function called when "back" button is clicked */
    @IBAction func backButton(_ sender: UIButton) {
        //Exit
        dismiss(animated: true, completion: nil)
    }
    
    ///////////////////////////
    //--- A function that stores the highscore given a key and a score obtained
    //////////////////////////
    static func storeHighScore(score: Int, name: String, keyScore: String, keyName: String){
        //Retrieve object for persient data
        let userDefaults = UserDefaults.standard
        
        //Retrieve highscores from persistent data
        guard var existingArray = userDefaults.object(forKey: keyScore) as? Array<Int> else {
            //If no Highscores, store array with 0 values
            userDefaults.set([score, 0, 0, 0, 0, 0], forKey: keyScore)
            userDefaults.set([name, "Empty", "Empty", "Empty", "Empty", "Empty"], forKey: keyName)
            return
        }
        
        //Retrieve Names
        var existingNames = userDefaults.object(forKey: keyName) as! Array<String>
        
        /* Iterate through highscores and check if the otained value is higher than any scores */
        for i in 0...existingArray.count - 1{
            if score >= existingArray[i] {
                //Insert highscore in respective position if it is greater than another entry
                existingArray.insert(score,at:i)
                existingNames.insert(name,at:i)
                if existingArray.count > 6 {
                    //Remove last element if list is too long
                    existingArray.removeLast()
                    existingNames.removeLast()
                }
                break
            }
            
        }
        //Replace old entry with new highscores
        userDefaults.set(existingArray, forKey: keyScore)
        userDefaults.set(existingNames, forKey: keyName)
        //Apply changes
        userDefaults.synchronize()
    }
    

}
