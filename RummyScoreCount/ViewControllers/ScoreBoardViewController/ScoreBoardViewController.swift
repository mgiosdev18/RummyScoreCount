//
//  ScoreBoardViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 03/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class ScoreBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var tblScoreBoard: UITableView!
    
    var gameID = ""
    var playerID = ""
    var playerScoreboardArr = Array<classPlayerScoresDict>()
    var cardsCount = Array<Int>()
    

    let cellSpacingHeight: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblScoreBoard.backgroundColor = .clear
        tblScoreBoard.tableFooterView = UIView()

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        playerScoreboardArr.removeAll()
        let gameDetails = self.getScoreBoardOf(gameID: gameID)
        
        if gameDetails.scoreBoard != nil
        {
            let scoreboardArr = gameDetails.scoreBoard as! [classPlayersDict]
            
            let getPlayerScoreDict = scoreboardArr.filter {$0.id == playerID}
            
            if getPlayerScoreDict.count != 0
            {
            
                playerScoreboardArr =  getPlayerScoreDict[0].scoreDictArray!
                var GrandTotal = 0
                
                
                for scoreDict in playerScoreboardArr
                {
                    GrandTotal +=  Int(scoreDict.score!)!
                    
                }
                
                lblGrandTotal.text = "Your Total Score : \(String(describing:GrandTotal))"
            }
        }
        
       
        
        tblScoreBoard.reloadData()
        
    }
    //MARK: - UITableView Delegate and Datasource Methods..
    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return playerScoreboardArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let playerScoreDict = playerScoreboardArr[indexPath.section]
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ScoreBoardTableViewCell") as! ScoreBoardTableViewCell
       

        Cell.backgroundColor = .clear
        Cell.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.layer.borderWidth = 0.5
        Cell.layer.cornerRadius = 10
        Cell.clipsToBounds = true

        if playerScoreDict.isHalfCount!
        {
            Cell.btnHalfCountCheckBox.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
        }
        else
        {
            Cell.btnHalfCountCheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
        }
        
        Cell.lblRoundTotal.text = "Total : \(String(describing: playerScoreDict.score!))"
        
        Cell.lblRoundTotal.textColor = UIColor.getCustomBlueColor()
        Cell.lblRoundTotal.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.lblRoundTotal.layer.borderWidth = 0.5
        Cell.lblRoundTotal.layer.cornerRadius = 10
        Cell.lblRoundTotal.clipsToBounds = true
        Cell.lblRoundTotal.textAlignment = .center
        
        
         let filterCards = playerScoreDict.cards?.filter {$0 > 0}
        
        
        
        if (filterCards?.count)! > 0
        {
            // show cards and hide systemcount label
            
            Cell.lblSystemCount.isHidden = true
            Cell.scoreCollectionView.isHidden = false
            
            let tempArray =  self.getCardImages(fromIndexArray: playerScoreDict.cards!)
            
            cardsCount.append(tempArray.count)
            
            Cell.cards = tempArray
            Cell.scoreCollectionView.reloadData()
            
            
        }
        else
        {
            // show systemcount label and hide cards
            
            Cell.lblSystemCount.isHidden = false
            Cell.scoreCollectionView.isHidden = true
            
            let pointsData = CommonObjectClass().GetSettingsData()
            
            cardsCount.append(0)
            
            if playerScoreDict.score == "0"
            {
                Cell.lblSystemCount.text = "Rummy"
            }
            else if playerScoreDict.score == pointsData.drop
            {
                Cell.lblSystemCount.text = "Drop"
            }
            else if playerScoreDict.score == pointsData.midDrop
            {
                Cell.lblSystemCount.text = "Mid.Drop"
            }
            else if playerScoreDict.score == pointsData.fullCount
            {
                Cell.lblSystemCount.text = "Full Count"
            }
           
 
        }
        
      
        /*
                
        Cell.images = allPlayerimagesArray[indexPath.section]
        Cell.names = allPlayerNamesArray[indexPath.section]
 
 
        
        */
        Cell.scoreCollectionView.backgroundColor = .clear
 
 
 
        return Cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            if cardsCount[indexPath.section] == 0
            {
                return 250
                
            }
            else if cardsCount[indexPath.section] > 0 && cardsCount[indexPath.section] <= 6
            {
                return 250
            }
            else if cardsCount[indexPath.section] > 6
            {
                return 450
            }
            else
            {
                return 250
            }
        }
        else
        {
            if cardsCount[indexPath.section] == 0
            {
                return 120
                
            }
            else if cardsCount[indexPath.section] > 0 && cardsCount[indexPath.section] <= 6
            {
                return 120
            }
            else if cardsCount[indexPath.section] > 6
            {
                return 175
            }
            else
            {
                return 120
            }
        }
        
     
        
        
        /*
        let imagesCount = allPlayerimagesArray[indexPath.section].count
        
        
        if imagesCount >= 1 && imagesCount <= 3
        {
            return 100.0;
        }
        else if imagesCount > 3 && imagesCount <= 6
        {
            return 200.0;
        }
        else if imagesCount > 6
        {
            return 200.0
        }
        else
        {
            return 100.0
        }
        */
        
       
        
    }
    
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }

    
    //MARK: - Helper Methods
    //MARK: -
    
    func getScoreBoardOf(gameID:String) -> NewGame
    {
        var gameResutls = NewGame()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "gameID == %@", gameID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "gameID == %@", gameID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                gameResutls = results![0]
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return gameResutls
    }
    
    func getCardImages(fromIndexArray : Array<Int>) -> Array<UIImage>
    {
        var TempArray = Array<UIImage>()
        for (index,value) in fromIndexArray.enumerated()
        {
            if value != 0
            {
                if index == 0
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "letter-a"), count: value))
                    
                }
                
                if index == 1
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "letter-j"), count: value))
                    
                }
                if index == 2
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "letter-q"), count: value))
                    
                }
                if index == 3
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "letter-k"), count: value))
                    
                }
                if index == 4
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "two"), count: value))
                    
                }
                if index == 5
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "three"), count: value))
                    
                }
                if index == 6
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "four"), count: value))
                    
                }
                if index == 7
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "five"), count: value))
                    
                }
                if index == 8
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "six"), count: value))
                    
                }
                if index == 9
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "seven"), count: value))
                    
                }
                if index == 10
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "eight"), count: value))
                    
                }
                if index == 11
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "nine"), count: value))
                    
                }
                if index == 12
                {
                    
                    TempArray.append(contentsOf: repeatElement(#imageLiteral(resourceName: "ten"), count: value))
                    
                }
       
                
            }

        }
        
        return TempArray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
