//
//  Add_Select_PlayersViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 03/07/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData
//MARK: - Players
//MARK: -
struct PlayersModel : Codable
{
    
    var id : String?
    var name : String?
    var image : Data?
    var gender  : String?
    var yob  : String?
    var gameID : String?
    var Scores : [[Int]]
    var Rounds : [[Int]]
    
    
}

class Add_Select_PlayersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {

    @IBOutlet weak var btnStartNewGame: UIButton!
    @IBOutlet weak var btnAddPlayer: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var playerCollectionView: UICollectionView!
    
    var arrAllPlayers = Array<PlayersModel>()
    var arrSelectedPlayerIDs = Array<String>()
    let numberOfCellsInRow: CGFloat = 3
    var commentsAlertView = UIView()
    var gameID = String()
    
    var arrcardsCount = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    var arrPlayerScores = Array<classPlayersDict>()
    
    weak var observer : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CommonObjectClass().EnableButtons(buttons: [btnStartNewGame], withBackgroundColor: .getCustomBlueColor())
        playerCollectionView.backgroundColor = .clear
        
        observer = NotificationCenter.default.addObserver(forName: .refreshView, object: nil, queue: OperationQueue.main, using: { (notificaiton) in
            print("iPad observer clicked")
            self.arrSelectedPlayerIDs.removeAll()
            self.getAllPlayers()
            
        })
 
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        arrSelectedPlayerIDs.removeAll()
        self.getAllPlayers()
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.playerCollectionView?.addGestureRecognizer(lpgr)
        
    }
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        //        if (gestureRecognizer.state != UIGestureRecognizerState.began){
        //            return
        //        }
        
        let point = gestureRecognizer.location(in: self.playerCollectionView)
    
        let indexPath = self.playerCollectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let cell = self.playerCollectionView.cellForItem(at: indexPath) as! PlayersCollectionViewCell
            print(cell.btnDelete.tag)
            self.EditPlayer(ofID: String(describing: "\(cell.btnDelete.tag)"))

        } else {
            print("Could not find index path")
        }
        
        
    }

    @IBAction func btnBackClicked(_ sender: UIBarButtonItem)
    {
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func btnAddPlayerClicked(_ sender: UIBarButtonItem)
    {

        if self.GetPlayersCount() == MaxPlayers
        {
            
            let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
            if UIDevice.current.userInterfaceIdiom != .pad
            {
                popOverVC.modalPresentationStyle = .popover
            }
            popOverVC.showOnlySingleButton  = true
            popOverVC.strMessage = "You can add maximum of \(MaxPlayers) players only"
          //  popOverVC.delegate = self
            popOverVC.onOKClicked = {(onOKCLicked) ->() in
                
                popOverVC.dismissAlertPop()
            }
            self.present(popOverVC, animated: true, completion: nil)
        }
        else
        {
            
            self.performSegue(withIdentifier: "popupSB", sender: "NEW")
            
        }
        
        
    }
    
    @IBAction func btnStartNewGameClicked(_ sender: UIButton)
    {
        if arrSelectedPlayerIDs.count >= 2
        {
            
            let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
            if UIDevice.current.userInterfaceIdiom != .pad
            {
                popOverVC.modalPresentationStyle = .popover
            }
            popOverVC.showOnlySingleButton = false
            popOverVC.strMessage = "Once game started you cannot come back. But you can 'End This Game' to play later.\nDo you want to start the game with selected players?"
            popOverVC.onNOClicked = {(noClickedStr) ->() in
                
                popOverVC.dismissAlertPop()
            }
            popOverVC.onYESClicked = { (str) -> () in
                
                popOverVC.dismissAlertPop()
                
                self.AddNewGameWithPlayers(PlayersID: self.arrSelectedPlayerIDs)
                
                
            }
            
            
            self.present(popOverVC, animated: true, completion: nil)
            
        }
        else
        {
            let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
            
            if UIDevice.current.userInterfaceIdiom != .pad
            {
                popOverVC.modalPresentationStyle = .popover
            }
          
            popOverVC.showOnlySingleButton  = true
            popOverVC.strMessage = "Please select atleast 2 players to start the game"
           // popOverVC.delegate = self
            popOverVC.onOKClicked = {(onOKClicked) -> () in
                popOverVC.dismissAlertPop()
                
            }
            self.present(popOverVC, animated: true, completion: nil)
            
        }
 
    }

    
    //MARK: - UICollection View delegates
    //MARK: -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrAllPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayersCollectionViewCell", for: indexPath) as! PlayersCollectionViewCell
        
        let player = arrAllPlayers[indexPath.row] as PlayersModel
        
        Cell.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.layer.borderWidth = 0.5
        Cell.layer.cornerRadius = 5
        Cell.clipsToBounds = true
        Cell.backgroundColor = UIColor.clear
        
        
        Cell.topView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        Cell.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        Cell.playerImg.image = UIImage.init(data: player.image!)
        
        
        
        
        Cell.lblGender.textColor = UIColor.getCustomBlueColor()
        if player.gender == "Male"
        {
            Cell.lblGender.text = "M"
            
        }
        else if player.gender == "Female"
        {
            Cell.lblGender.text = "F"
        }
        else
        {
            Cell.lblGender.text = ""
        }
        
        Cell.lblPlayerName.text = player.name!.uppercased()
        Cell.lblPlayerName.textColor = UIColor.getCustomBlueColor()
        
        Cell.btncheckBox.addTarget(self, action: #selector(btnCheckBoxClicked(sender:)), for: .touchUpInside)
        Cell.btncheckBox.tag = Int(player.id!)!
        
        Cell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked(sender:)), for: .touchUpInside)
        Cell.btnDelete.tag = Int(player.id!)!
        
        if arrSelectedPlayerIDs.contains(player.id!)
        {
            Cell.btncheckBox.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
            Cell.btncheckBox.isSelected = true
            
        }
        else
        {
            Cell.btncheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
            Cell.btncheckBox.isSelected = false
        }

        
        
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth : CGFloat = playerCollectionView.frame.size.width / numberOfCellsInRow
        let cellheight : CGFloat = playerCollectionView.frame.size.width / numberOfCellsInRow
        let cellSize = CGSize(width: cellWidth-10 , height:cellheight-10)
        
        return cellSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PlayersCollectionViewCell
        
        cell?.btncheckBox.isSelected = !(cell?.btncheckBox.isSelected)!
        
        if (cell?.btncheckBox.isSelected)!
        {
            cell?.btncheckBox.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
            
            let selectedPlayerID = String(describing: (cell?.btncheckBox.tag)!)
            
            arrSelectedPlayerIDs.append(selectedPlayerID)
            
            
        }
        else
        {
            cell?.btncheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
            
             let deletePlayerID = String(describing: (cell?.btncheckBox.tag)!)
            
            if let index = arrSelectedPlayerIDs.index(of:deletePlayerID) {
                arrSelectedPlayerIDs.remove(at: index)
            }
            
        }
        
        print("selected players : \(arrSelectedPlayerIDs)")
        
        
    }
    
    @objc func btnCheckBoxClicked(sender : UIButton) -> Void
    {
     
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected
        {
            sender.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
            arrSelectedPlayerIDs.append(String(describing: sender.tag))
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
            if let index = arrSelectedPlayerIDs.index(of: String(describing: sender.tag)) {
                arrSelectedPlayerIDs.remove(at: index)
            }
        }
        
        print("selected players : \(arrSelectedPlayerIDs)")
        
    }
    
    @objc func btnDeleteClicked(sender:UIButton) -> Void
    {
      
        
        let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
        if UIDevice.current.userInterfaceIdiom != .pad
        {
            popOverVC.modalPresentationStyle = .popover
        }
        popOverVC.showOnlySingleButton = false
        popOverVC.strMessage = "This Player will delete from all games which are completed and continued games.Do you want to delete this player?"
        popOverVC.onNOClicked = {(noClickedStr) ->() in

            popOverVC.dismissAlertPop()
        }
        popOverVC.onYESClicked = { (str) -> () in
            popOverVC.dismissAlertPop()
            
            if let index = self.arrSelectedPlayerIDs.index(of: String(describing: sender.tag)) {
                self.arrSelectedPlayerIDs.remove(at: index)
            }
            self.deletePlayer(ofID:sender.tag)
            
        }
        
        self.present(popOverVC, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Helper Methods
    //MARK: -
    
    func getAllPlayers() -> Void
    {
        self.arrAllPlayers.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Players>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Players.fetchRequest()
            
        } else {
            request = NSFetchRequest(entityName: "Players")
            
        }
        do {
            
            let results = try managedContext.fetch(request)
            
            if results.count != 0
            {
                for players in results
                {
                    
                    let playermodel = PlayersModel(id:players.id!, name: players.name!, image: players.avatar!, gender: players.gender!, yob: players.yearOfBirth!,gameID: gameID,Scores:[],Rounds:[])
                    
                    arrAllPlayers.append(playermodel)
                    
                    
                }
                
                playerCollectionView.reloadData()
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func deletePlayer(ofID:Int) -> Void
    {
        print("Deleting player")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Players>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Players.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", String(describing: ofID) )
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "Players")
            let predicate = NSPredicate(format: "id == %@", String(describing: ofID))
            request.predicate = predicate
            
        }
        do {
            
            let results = try managedContext.fetch(request)
            
            if results.count != 0
            {
                managedContext.delete(results[0])
                
                
                do {
                    try managedContext.save()
                    
                    self.DeleteFromAllGames(playerID:String(describing: "\(ofID)"))
                    
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    
    }
    
    func DeleteFromAllGames(playerID:String) -> Void
    {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
          //  let predicate = NSPredicate(format: "gameID == %@", ID)
          //  request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
          //  let predicate = NSPredicate(format: "gameID == %@", ID)
          //  request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                
                for(index,value) in (results?.enumerated())!
                {
                    print(index)
                    print(value)
                    
                    if value.winnerID == playerID
                    {
                        value.winnerID = ""
                    }
                    
                    let tempRunningIDArr = value.runnigPlayerIDs?.components(separatedBy: ",")
                    let filterArrRunningIs = tempRunningIDArr?.filter {$0 != playerID}
                    value.runnigPlayerIDs = filterArrRunningIs?.joined(separator: ",")
                    
                    let tempCompletedIDArr = value.compltedPlayerIDs?.components(separatedBy: ",")
                    let filterArrCompletedIds = tempCompletedIDArr?.filter {$0 != playerID}
                    value.compltedPlayerIDs = filterArrCompletedIds?.joined(separator: ",")
                    
                    if value.scoreBoard != nil
                    {
                        let classPlayersDictArr = value.scoreBoard as! [classPlayersDict]
                        
                        let fileterArr = classPlayersDictArr.filter {$0.id != playerID}
                        
                        value.scoreBoard = fileterArr as NSObject
                    }
                    
                   
                    
                    do {
                        try managedContext?.save()
                    } catch let error as NSError {
                        print("Count't save..\(error.description)")
                        
                    }
                    
                    
                }
                playerCollectionView.reloadData()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    func GetPlayersCount() -> Int
    {
        
        var count = Int()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Players>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Players.fetchRequest()
            
        } else {
            request = NSFetchRequest(entityName: "Players")
        }
        do {
            
            let results = try managedContext.fetch(request)
            
            if results.count != 0
            {
                count = results.count
                
                return count
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return count
    }
    
  
    func AddNewGameWithPlayers(PlayersID:Array<String>) -> Void
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "NewGame", in: managedContext)!
        
        let newGamePlayer = NSManagedObject(entity: entity, insertInto: managedContext) as! NewGame
        
        let 
        
        gameID = CommonObjectClass().AddNewIDFor(key: newPlayerID)
        
        newGamePlayer.gameID = gameID
        newGamePlayer.isCompleted = false
        
        let playersSet = NSMutableSet()
      //  var playerArray = [Players]()

        for playerID in PlayersID
        {
            let player: Players =  self.getPlayer(ofID: playerID)
            playersSet.add(player)
            //playerArray.append(player)
            newGamePlayer.player = playersSet
           // newGamePlayer.playersObj = playerArray as NSObject
            
            
        }


        newGamePlayer.runnigPlayerIDs = PlayersID.joined(separator: ",")
        newGamePlayer.winnerID = ""
        //newGamePlayer.gameTotal =CommonObjectClass().getGameTotal()

        
        do {
            try managedContext.save()
            self.performSegue(withIdentifier: "Game", sender: gameID)
        } catch let error as NSError {
            print("Count't save..\(error.description)")
            
        }
        
    }
    func getPlayer(ofID:String) -> Players
    {
        print("Deleting player")
        var player = Players()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return player
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Players>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Players.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", ofID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "Players")
            let predicate = NSPredicate(format: "id == %@", ofID)
            request.predicate = predicate
            
        }
        do {
            
            let results = try managedContext.fetch(request)
            
            if results.count != 0
            {
                player = results[0]
                
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return player
    }
    func EditPlayer(ofID:String) -> Void
    {
        self.performSegue(withIdentifier: "popupSB", sender: ofID)
    }
    
    
    deinit {
        debugLog(object: self)
    }

    // MARK: - Segue Navigation
    //MARK: -
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Game"
        {
            let NewGameVC : NewGameViewController = segue.destination as! NewGameViewController
          //  NewGameVC.arrGamePlayersID = arrSelectedPlayerIDs
            NewGameVC.gameID = sender! as! String
        }
        
        if segue.identifier == "popupSB"
        {
            let newPlayerVC : NewPlayerPopUp = segue.destination as! NewPlayerPopUp
           
            if ( sender as? String) != "NEW"
            {
                newPlayerVC.doEdit = true
                newPlayerVC.playerID = (sender as? String)!
            }
            
          
            
        }

    }
    

}

extension Add_Select_PlayersViewController : popUpDelegate
{
    func getOkClicked(str: String) {

    }
    
 
}

