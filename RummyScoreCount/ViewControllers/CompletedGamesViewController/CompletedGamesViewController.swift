//
//  CompletedGamesViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 30/06/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class CompletedGamesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var tblCompletedGames: UITableView!
    
    var allPlayerimagesArray = [[Data]]()
    var allPlayerNamesArray = [[String]]()
    var allGameIDsArray = Array<String>()
    let cellSpacingHeight: CGFloat = 30
    
    var emptyLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CreateEmptyLabel()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIColor.getCustomBlueColor().as1ptImage()
        let completedGamesArray = self.getCompletedGamesList()
        
        if completedGamesArray.count == 0
        {
            emptyLabel.isHidden = false
        }
        else
        {
            emptyLabel.isHidden = true
            
            for completedGame in completedGamesArray {
                var playerImagesArr = [Data]()
                var playerNamesArr = [String]()
                
                
                
                let playersArray = completedGame.player?.allObjects as! [Players]
                
                if playersArray.count > 1
                {
                    allGameIDsArray.append(completedGame.gameID!)
                    let runningPlayerIDsArr = completedGame.runnigPlayerIDs?.components(separatedBy: ",")
                    
                    for playerID in runningPlayerIDsArr!
                    {
                        let playerFilterArray = playersArray.filter{$0.id == playerID}
                        
                        if playerFilterArray.count != 0
                        {
                            playerImagesArr.append(playerFilterArray[0].avatar!)
                            playerNamesArr.append(playerFilterArray[0].name!)
                        }
                        
                    }
                    
                    let completedPlayerIDsArr = completedGame.compltedPlayerIDs?.components(separatedBy: ",")
                    
                    for playerID in completedPlayerIDsArr!
                    {
                        let playerFilterArray = playersArray.filter{$0.id == playerID}
                        
                        if playerFilterArray.count != 0
                        {
                            playerImagesArr.append(playerFilterArray[0].avatar!)
                            playerNamesArr.append(playerFilterArray[0].name!)
                        }
                        
                        
                    }
                    
                    allPlayerimagesArray.append(playerImagesArr)
                    allPlayerNamesArray.append(playerNamesArr)
                }
                else
                {
                    DelelteGame(withID: completedGame.gameID!)
                }
        
            }
        }
 
        tblCompletedGames.tableFooterView = UIView()
        tblCompletedGames.backgroundColor = .clear
    
        
    }
    
    @IBAction func btnMenuClicked(_ sender: UIBarButtonItem)
    {
        sideMenuVC.toggleMenu()
    }
    
    
    //MARK: - UITableView Delegate and Datasource Methods..
    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return allPlayerimagesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CompletedGamesTableViewCell") as! CompletedGamesTableViewCell
        
        Cell.backgroundColor = .clear
        Cell.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.layer.borderWidth = 0.5
        Cell.layer.cornerRadius = 10
        Cell.clipsToBounds = true
        
        Cell.btnViewScores.titleLabel?.sizeToFit()
        Cell.btnViewScores.titleLabel?.minimumScaleFactor = 0.5
        Cell.btnViewScores.titleLabel?.numberOfLines = 0
        Cell.btnViewScores.titleLabel?.textAlignment = .center
        
        
        
        CommonObjectClass().EnableButtons(buttons: [Cell.btnViewScores], withBackgroundColor: .getCustomBlueColor())
        Cell.btnViewScores.addTarget(self, action: #selector(btnViewScoresClicked(sender:)), for: .touchUpInside)
        Cell.btnViewScores.tag = indexPath.section
        
        Cell.images = allPlayerimagesArray[indexPath.section]
        Cell.names = allPlayerNamesArray[indexPath.section]
        Cell.tblCollectionView.reloadData()
        Cell.tblCollectionView.backgroundColor = .clear
   
        return Cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let imagesCount = allPlayerimagesArray[indexPath.section].count
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            if imagesCount >= 1 && imagesCount <= 3
            {
                return 300.0;
            }
            else if imagesCount > 3 && imagesCount <= 6
            {
                return 500.0;
            }
            else if imagesCount > 6
            {
                return 500.0
            }
            else
            {
                return 300.0
            }
        }
        else
        {
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
        }
        
     
        
       
    }

    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        let label = UILabel(frame: CGRect(x:10, y:5, width:tableView.frame.size.width, height:20))
        label.font = UIFont.boldSystemFont(ofSize: 20)
      //  label.text = list.objectAtIndex(indexPath.row) as! String
        label.text = ""
        label.textColor = UIColor.white
        view.addSubview(label)
        view.backgroundColor = UIColor.clear // Set your background color

        return view
    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return "Ganesh"
//
//    }
    
    //MARK: - Helper Methods
    //MARK: -
    
    func CreateEmptyLabel() -> Void
    {
        emptyLabel = UILabel(frame: CGRect(x: 0, y: (screenHeight/2) - 20, width: screenWidth, height: 40))
        emptyLabel.text = "You don't have any completed games"
        emptyLabel.textColor = UIColor.getCustomBlueColor()
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 30)
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.minimumScaleFactor = 0.5
        emptyLabel.numberOfLines = 0
        self.view.addSubview(emptyLabel)

    }
    
    func getCompletedGamesList() -> [NewGame]
    {
        
        var CompletedGamesArray = [NewGame]()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                CompletedGamesArray = results!
                
                
                do {
                    try managedContext?.save()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return CompletedGamesArray
    }
    
    func DelelteGame(withID:String) -> Void
    {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "gameID == %@", withID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "gameID == %@", withID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                
                managedContext?.delete((results?[0])!)
                
                
                do {
                    try managedContext?.save()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    @objc func btnViewScoresClicked(sender:UIButton) -> Void
    {
        self.performSegue(withIdentifier: "FromCompletedGameSegue", sender: sender)
    }
    
    deinit {
        debugLog(object: self)
    }
 
    //MARK: - Segue Navigation
    //MARK: -

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "AllScoreBoardViewControllerSegue"
        {
            let AllScoresBoardVC : AllScoreBoardViewController = segue.destination as! AllScoreBoardViewController
            
            if let btn = sender as? UIButton
            {
                AllScoresBoardVC.gameID = allGameIDsArray[btn.tag]
            }
  
        }
        if segue.identifier == "FromCompletedGameSegue"
        {
            let NewGameVC : NewGameViewController = segue.destination as! NewGameViewController
            // NewGameVC.arrGamePlayersID = arrSelectedPlayerIDs
          //  let index = sender as! Int
            
            if let btn = sender as? UIButton
            {
                NewGameVC.gameID =  allGameIDsArray[btn.tag]
                NewGameVC.isGameCompleted  = true
            }
            
            
        }
        
        
    }


}





















