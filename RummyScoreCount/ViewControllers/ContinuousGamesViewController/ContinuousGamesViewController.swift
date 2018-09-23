//
//  ContinuousGamesViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 30/06/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class ContinuousGamesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblContinue: UITableView!
    var allPlayerimagesArray = [[Data]]()
    let cellSpacingHeight: CGFloat = 30
    var allPlayerNamesArray = [[String]]()
    var gameIDsArray = [String]()
    var emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.shadowImage = UIColor.getCustomBlueColor().as1ptImage()

        
       // let forceToLandScapeLeft = UIInterfaceOrientation.landscapeLeft.rawValue
       // UIDevice.current.setValue(forceToLandScapeLeft, forKey: "orientation")
        
       
        
        tblContinue.tableFooterView = UIView()
        tblContinue.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.CreateEmptyLabel()
        gameIDsArray.removeAll()
        allPlayerimagesArray.removeAll()
        allPlayerNamesArray.removeAll()
        
        let continueGamesArray = self.getContinuesGamesList()
        
        
        if continueGamesArray.count == 0
        {
            emptyLabel.isHidden = false
            
        }
        else
        {
            emptyLabel.isHidden = true
            
            for continueGame in continueGamesArray {
                
                
                var playerImagesArr = [Data]()
                var playerNamesArr = [String]()
                
                let playersArray = continueGame.player?.allObjects as! [Players]
                
                if playersArray.count > 1
                {
                    gameIDsArray.append(continueGame.gameID!)

                    let runningPlayerIDsArr = continueGame.runnigPlayerIDs?.components(separatedBy: ",")
                    
                    for playerID in runningPlayerIDsArr!
                    {
                        let playerFilterArray = playersArray.filter{$0.id == playerID}
                        
                        if playerFilterArray.count != 0
                        {
                            playerImagesArr.append(playerFilterArray[0].avatar!)
                            playerNamesArr.append(playerFilterArray[0].name!)
                        }
                        
                        
                        
                    }
                    
                    if continueGame.compltedPlayerIDs != nil
                    {
                        let completedPlayerIDsArr = continueGame.compltedPlayerIDs?.components(separatedBy: ",")
                        
                        for playerID in completedPlayerIDsArr!
                        {
                            let playerFilterArray = playersArray.filter{$0.id == playerID}
                            
                            if playerFilterArray.count != 0
                            {
                                playerImagesArr.append(playerFilterArray[0].avatar!)
                                playerNamesArr.append(playerFilterArray[0].name!)
                            }
                            
                        }
                    }
                    
                    allPlayerimagesArray.append(playerImagesArr)
                    allPlayerNamesArray.append(playerNamesArr)
                }
                else
                {
                    //delete the game...
                    self.DelelteGame(withID:continueGame.gameID!)
 
                }
  
            }
            
        }

        
        tblContinue.reloadData()
    }
    
    /*
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool
    {
        return false
    }
 */

    
    @IBAction func btnMenuClicked(_ sender: UIBarButtonItem)
    {
        sideMenuVC.toggleMenu()
    }
    
    
    //MARK: - Helper Methods
    //MARK: -
    
    func CreateEmptyLabel() -> Void
    {
        emptyLabel = UILabel(frame: CGRect(x: 0, y: (screenHeight/2) - 20, width: screenWidth, height: 40))
        emptyLabel.text = "You don't have any Continuous games"
        emptyLabel.textColor = UIColor.getCustomBlueColor()
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 30)
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.minimumScaleFactor = 0.5
        emptyLabel.numberOfLines = 0
        self.view.addSubview(emptyLabel)
        
    }
    
    func getContinuesGamesList() -> [NewGame]
    {
        
        var ContinuesGamesArray = [NewGame]()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                ContinuesGamesArray = results!
                
                
                do {
                    try managedContext?.save()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ContinuesGamesArray
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
    
    @objc func btnContinueClicked(sender:UIButton) -> Void
    {
        
        self.performSegue(withIdentifier: "continueSegue", sender: sender.tag)
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
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell") as! ContinueTableViewCell
        
        Cell.backgroundColor = .clear
        Cell.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.layer.borderWidth = 0.5
        Cell.layer.cornerRadius = 10
        Cell.clipsToBounds = true
        
        Cell.btnContinue.titleLabel?.sizeToFit()
        Cell.btnContinue.titleLabel?.minimumScaleFactor = 0.5
        Cell.btnContinue.titleLabel?.numberOfLines = 0
        Cell.btnContinue.titleLabel?.textAlignment = .center
        
        CommonObjectClass().EnableButtons(buttons: [Cell.btnContinue], withBackgroundColor: .getCustomBlueColor())
        Cell.btnContinue.addTarget(self, action: #selector(btnContinueClicked(sender:)), for: .touchUpInside)
        Cell.btnContinue.tag = indexPath.section
        
        Cell.images = allPlayerimagesArray[indexPath.section]
        Cell.names = allPlayerNamesArray[indexPath.section]
        Cell.collnView.reloadData()
        Cell.collnView.backgroundColor = .clear
        
        return Cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    deinit {
        debugLog(object: self)
    }
    
    
    // MARK: - Segue Naviagation
    //MARK: -

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continueSegue"
        {
            let NewGameVC : NewGameViewController = segue.destination as! NewGameViewController
           // NewGameVC.arrGamePlayersID = arrSelectedPlayerIDs
            let index = sender as! Int
            
            NewGameVC.gameID =  gameIDsArray[index]
        }



    }


}
