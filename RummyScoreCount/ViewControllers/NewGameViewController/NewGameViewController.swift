//
//  NewGameViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 28/07/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData
class NewGameViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var NewGameCollectionView: UICollectionView!
    @IBOutlet weak var btnEndThisGame: UIButton!
    @IBOutlet weak var btnAddPlayer: UIButton!
    @IBOutlet weak var lblTotalGamePoints: UILabel!
    @IBOutlet weak var lblTotalPlayers: UILabel!
    @IBOutlet weak var lblActivePlayers: UILabel!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var lblRound: UILabel!
    
    var gameID = String()
    var isGameCompleted = false
    
    var arrSelectedPlayers = Array<PlayersModel>()
    var arrActivePlayers = Array<PlayersModel>()
    var arrScores = [[Int]]()
    var playerRoundsArray = [[Int]]()
    var RoundStatusArray = Array<String>()
    var winnderID = String()
    var isDisablePlayerChecked = false
    var totalGamePoints = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.isEnabled = false
        
        NewGameCollectionView.backgroundColor = .clear
        CommonObjectClass().EnableButtons(buttons: [btnEndThisGame,btnAddPlayer], withBackgroundColor: .getCustomBlueColor())
        
      //  print("arrGamePlayersID : \(gameID)")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        totalGamePoints = CommonObjectClass().GetSettingsData().totalPoints
        
        self.UpdateView()
    }
    
    func UpdateView() -> Void
    {
        arrScores.removeAll()
        arrSelectedPlayers.removeAll()
        playerRoundsArray.removeAll()
        RoundStatusArray.removeAll()
        arrActivePlayers.removeAll()

        if isGameCompleted
        {
            CommonObjectClass().DisableButtons(buttons: [btnAddPlayer,btnEndThisGame], withBackgroundColor: .clear)
            
            btnBack.isEnabled = true
        }
        
        
        let newgame = self.getNewGameDetailsWith(ID: gameID)
        
        if newgame.runnigPlayerIDs != nil
        {
            let arrPlayerIDs = newgame.runnigPlayerIDs?.components(separatedBy: ",")
            
            for playerID in arrPlayerIDs!
            {
                let playerid = playerID as String
                
                if newgame.scoreBoard != nil
                {
                    
                    let arrplayerdict = newgame.scoreBoard as! [classPlayersDict]
                    
                    let filterdArr = arrplayerdict.filter {$0.id == playerid}
                    
                    if filterdArr.count == 0
                    {
                        var arrscore = Array<Int>()
                        arrscore.append(0)
                        arrScores.append(arrscore)
                        
                        var arrround = Array<Int>()
                        arrround.append(0)
                        playerRoundsArray.append(arrround)
                    }
                    else
                    {
                        
                        let Arrscoredict  = filterdArr[0].scoreDictArray
                        
                        var arrscore = Array<Int>()
                        var arrround = Array<Int>()
                        
                        for scoredict in Arrscoredict!
                        {
                            arrscore.append(Int(scoredict.score!)!)
                            arrround.append(scoredict.round)
                            
                            let savedRound = IDDefaults.value(forKey: "\(gameID)_Rounds") as! Int
                            
                            if savedRound < scoredict.round
                            {
                                IDDefaults.set(scoredict.round, forKey: "\(gameID)_Rounds")
                                
                            }
                            
                        }
                        
                        arrScores.append(arrscore)
                        playerRoundsArray.append(arrround)
                    }
                    
                    
                  //  print(arrScores)
                    //  print(playerRoundsArray)
                    
                }
                
                
                let playerTupple = self.getPlayerDetialsUsing(ID:playerid)
                
                if playerTupple.isExist
                {
                    let player = playerTupple.players
                    
                    if player.id != ""
                    {
                        let playermodel = PlayersModel(id: player.id, name: player.name!, image: player.avatar!, gender: player.gender!, yob: player.yearOfBirth!,gameID:gameID,Scores:arrScores, Rounds:playerRoundsArray)
                        
                        arrSelectedPlayers.append(playermodel)
                        arrActivePlayers.append(playermodel)
                    }
                }

            }
            
        }
      
        // completed player IDs
        
        if newgame.compltedPlayerIDs != nil
        {
            let arrCompletePlayerIDs = newgame.compltedPlayerIDs?.components(separatedBy: ",")
            
            for completedPlayerID in arrCompletePlayerIDs!
            {
                let playerid = completedPlayerID as String
                
                if newgame.scoreBoard != nil
                {
                    
                    let arrplayerdict = newgame.scoreBoard as! [classPlayersDict]
                    
                    let filterdArr = arrplayerdict.filter {$0.id == playerid}
                    
                    if filterdArr.count == 0
                    {
                        var arrscore = Array<Int>()
                        arrscore.append(0)
                        arrScores.append(arrscore)
                        
                        var arrround = Array<Int>()
                        arrround.append(0)
                       // playerRoundsArray.append(arrround)
                    }
                    else
                    {
                        
                        let Arrscoredict  = filterdArr[0].scoreDictArray
                        
                        var arrscore = Array<Int>()
                        var arrround = Array<Int>()
                        
                        for scoredict in Arrscoredict!
                        {
                            arrscore.append(Int(scoredict.score!)!)
                            arrround.append(scoredict.round)
                            
                            let savedRound = IDDefaults.value(forKey: "\(gameID)_Rounds") as! Int
                            
                            if savedRound < scoredict.round
                            {
                                IDDefaults.set(scoredict.round, forKey: "\(gameID)_Rounds")
                                
                            }
                            
                        }
                        
                        arrScores.append(arrscore)
                       // playerRoundsArray.append(arrround)
                    }
                    
                    
                  
                    
                }
                
                let playerTupple = self.getPlayerDetialsUsing(ID:playerid)
                
                if playerTupple.isExist
                {
                    let player = playerTupple.players
                    
                    if player.id != ""
                    {
                        let playermodel = PlayersModel(id: player.id, name: player.name!, image: player.avatar!, gender: player.gender!, yob: player.yearOfBirth!,gameID:gameID,Scores:arrScores, Rounds:[])
                        
                        arrSelectedPlayers.append(playermodel)
                        arrActivePlayers.append(playermodel)
                    }
                }
   
                
               
            }
        }
        
        print(arrScores)
        print(playerRoundsArray)
 
        if playerRoundsArray.count != 0
        {
            for roundArray in playerRoundsArray
            {
                let savedRound = IDDefaults.value(forKey: "\(gameID)_Rounds") as! Int
                
                if roundArray.count == savedRound
                {
                    if roundArray.count == 1
                    {
                        if roundArray.first == 0
                        {
                            RoundStatusArray.append("NO")
                        }
                        else
                        {
                            RoundStatusArray.append("YES")
                        }
                    }
                    else
                    {
                        RoundStatusArray.append("YES")
                    }
                }
                else
                {
                    RoundStatusArray.append("NO")
                }
            }
        }
        
        print(RoundStatusArray)
        
        lblTotalGamePoints.text = "Total Game Points : \(String(describing: totalGamePoints))"
        lblTotalPlayers.text = "Total Players : \(arrSelectedPlayers.count)"
        lblActivePlayers.text = "Active Players : \(arrActivePlayers.count)"
        
        
        NewGameCollectionView.reloadData()
        
//        if isDisablePlayerChecked
//        {
//            isDisablePlayerChecked = false
//        }
//        else
//        {
            self.checkForDisablePlayers(ScoresArr: arrScores, playersArray: arrSelectedPlayers)

      //  }
        
        

    }
    
    func UpdateViewForDisablePlayers() -> Void
    {
        arrScores.removeAll()
        arrSelectedPlayers.removeAll()
        playerRoundsArray.removeAll()
        RoundStatusArray.removeAll()
        arrActivePlayers.removeAll()
        
        let newgame = self.getNewGameDetailsWith(ID: gameID)
        
        if newgame.runnigPlayerIDs != nil
        {
            let arrPlayerIDs = newgame.runnigPlayerIDs?.components(separatedBy: ",")
            
            if arrPlayerIDs?.count == 1
            {
                winnderID = (arrPlayerIDs?.first)!
                
                self.updateWinnerID(playerID: (arrPlayerIDs?.first)!, ID: gameID)
            }
            
            for playerID in arrPlayerIDs!
            {
                
                let playerid = playerID as String
                
                if playerid != ""
                {
                    if newgame.scoreBoard != nil
                    {
                        
                        let arrplayerdict = newgame.scoreBoard as! [classPlayersDict]
                        
                        let filterdArr = arrplayerdict.filter {$0.id == playerid}
                        
                        if filterdArr.count == 0
                        {
                            var arrscore = Array<Int>()
                            arrscore.append(0)
                            arrScores.append(arrscore)
                            
                            var arrround = Array<Int>()
                            arrround.append(0)
                            playerRoundsArray.append(arrround)
                        }
                        else
                        {
                            
                            let Arrscoredict  = filterdArr[0].scoreDictArray
                            
                            var arrscore = Array<Int>()
                            var arrround = Array<Int>()
                            
                            for scoredict in Arrscoredict!
                            {
                                arrscore.append(Int(scoredict.score!)!)
                                arrround.append(scoredict.round)
                                
                                let savedRound = IDDefaults.value(forKey: "\(gameID)_Rounds") as! Int
                                
                                if savedRound < scoredict.round
                                {
                                    IDDefaults.set(scoredict.round, forKey: "\(gameID)_Rounds")
                                    
                                }
                                
                            }
                            
                            arrScores.append(arrscore)
                            playerRoundsArray.append(arrround)
                        }
                        
                        
                      //  print(arrScores)
                        //  print(playerRoundsArray)
                        
                    }
                    let playerTupple = self.getPlayerDetialsUsing(ID:playerid)
                    
                    if playerTupple.isExist
                    {
                        let player = playerTupple.players
                        
                        if player.id != ""
                        {
                            let playermodel = PlayersModel(id: player.id, name: player.name!, image: player.avatar!, gender: player.gender!, yob: player.yearOfBirth!,gameID:gameID,Scores:arrScores, Rounds:playerRoundsArray)
                            
                            arrSelectedPlayers.append(playermodel)
                            arrActivePlayers.append(playermodel)
                        }
                    }
                    
                  
                }
                

            }
            
        }
        
       
        // completed player IDs
        
        if newgame.compltedPlayerIDs != nil
        {
            let arrCompletePlayerIDs = newgame.compltedPlayerIDs?.components(separatedBy: ",")
            
            for completedPlayerID in arrCompletePlayerIDs!
            {
                let playerid = completedPlayerID as String
                
                if newgame.scoreBoard != nil
                {
                    
                    let arrplayerdict = newgame.scoreBoard as! [classPlayersDict]
                    
                    let filterdArr = arrplayerdict.filter {$0.id == playerid}
                    
                    if filterdArr.count == 0
                    {
                        var arrscore = Array<Int>()
                        arrscore.append(0)
                        arrScores.append(arrscore)
                        
                        var arrround = Array<Int>()
                        arrround.append(0)
                      //  playerRoundsArray.append(arrround)
                    }
                    else
                    {
                        
                        let Arrscoredict  = filterdArr[0].scoreDictArray
                        
                        var arrscore = Array<Int>()
                        var arrround = Array<Int>()
                        
                        for scoredict in Arrscoredict!
                        {
                            arrscore.append(Int(scoredict.score!)!)
                            arrround.append(scoredict.round)
                            
                            let savedRound = IDDefaults.value(forKey: "\(gameID)_Rounds") as! Int
                            
                            if savedRound < scoredict.round
                            {
                                IDDefaults.set(scoredict.round, forKey: "\(gameID)_Rounds")
                                
                            }
                            
                        }
                        
                        arrScores.append(arrscore)
                       // playerRoundsArray.append(arrround)
                    }
                    
                    
                   // print(arrScores)
                    //  print(playerRoundsArray)
                    
                }
                let playerTupple = self.getPlayerDetialsUsing(ID:playerid)
                
                if playerTupple.isExist
                {
                    let player = playerTupple.players
                    
                    if player.id != ""
                    {
                        let playermodel = PlayersModel(id: player.id, name: player.name!, image: player.avatar!, gender: player.gender!, yob: player.yearOfBirth!,gameID:gameID,Scores:arrScores, Rounds:[])
                        
                        arrSelectedPlayers.append(playermodel)
                        arrActivePlayers.append(playermodel)
                    }
                }

               
            }
        }
        
        print(arrScores)
        print(playerRoundsArray)
        
        
        if playerRoundsArray.count != 0
        {
            for roundArray in playerRoundsArray
            {
                let savedRound = IDDefaults.value(forKey: "\(gameID)_Rounds") as! Int
                
                if roundArray.count == savedRound
                {
                    if roundArray.count == 1
                    {
                        if roundArray.first == 0
                        {
                            RoundStatusArray.append("NO")
                        }
                        else
                        {
                            RoundStatusArray.append("YES")
                        }
                    }
                    else
                    {
                        RoundStatusArray.append("YES")
                    }
                }
                else
                {
                    RoundStatusArray.append("NO")
                }
            }
        }
        
        print(RoundStatusArray)
        
        lblTotalGamePoints.text = "Total Game Points : \(String(describing: totalGamePoints))"
        lblTotalPlayers.text = "Total Players : \(arrSelectedPlayers.count)"
        lblActivePlayers.text = "Active Players : \(arrActivePlayers.count)"
        
        
        NewGameCollectionView.reloadData()
        
        
    }
    
    @IBAction func btnBackClicked(_ sender: UIBarButtonItem)
    {
        
        
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEndThisGameClicked(_ sender: UIButton)
    {
        
         let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
        if UIDevice.current.userInterfaceIdiom != .pad
        {
            popOverVC.modalPresentationStyle = .popover
        }
         popOverVC.showOnlySingleButton = false
        popOverVC.strMessage = """
        This will exits from this game only if not completed.and you can continue this game in later.
        Do you want to proceed
        """
         popOverVC.onNOClicked = {(noClickedStr) ->() in
         
            popOverVC.dismissAlertPop()
         }
         popOverVC.onYESClicked = { (str) -> () in
         
            popOverVC.dismissAlertPop()
            let _ = self.navigationController?.popViewController(animated: true)

         }
         
         self.present(popOverVC, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func btnAddPlayerClicked(_ sender: UIButton)
    {
        let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
        if UIDevice.current.userInterfaceIdiom != .pad
        {
            popOverVC.modalPresentationStyle = .popover
        }
        popOverVC.showOnlySingleButton  = true
        popOverVC.strMessage = "Will coming soon in next version"
        // popOverVC.delegate = self
        popOverVC.onOKClicked  = {(onOKClciked) -> Void in
            popOverVC.dismissAlertPop()
        }
        self.present(popOverVC, animated: true, completion: nil)
        
        
    }
    
    //MARK: - UICollection View delegates
    //MARK: -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSelectedPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGameCollectionViewCell", for: indexPath) as! NewGameCollectionViewCell
        
        let playerData = arrSelectedPlayers[indexPath.row]
        
        Cell.backgroundColor = .clear
        Cell.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.layer.borderWidth = 1.0
        Cell.layer.cornerRadius = 5
        Cell.clipsToBounds = true
        
        Cell.btnName.backgroundColor = UIColor.getCustomBlueColor()
        Cell.btnName.setTitle(playerData.name!.uppercased(), for: .normal)
        Cell.btnName.isUserInteractionEnabled = false
        Cell.btnName.titleLabel?.numberOfLines = 0
        Cell.btnName.titleLabel?.minimumScaleFactor = 0.5
        Cell.btnName.titleLabel?.adjustsFontSizeToFitWidth = true
        
        Cell.btnTotal.backgroundColor = .getCustomBlueColor()
        Cell.btnTotal.isUserInteractionEnabled = false
       
        Cell.vwCompleted.isHidden = true
   
        Cell.playerImage.backgroundColor = .clear
        Cell.playerImage.layer.cornerRadius = Cell.playerImage.frame.width/2
        Cell.playerImage.clipsToBounds = true
        Cell.playerImage.image = UIImage(data: playerData.image!)
        
        
        //print(RoundStatusArray)
        
        if RoundStatusArray.count != 0
        {
            if RoundStatusArray.allEqual()
            {
                CommonObjectClass().EnableButtons(buttons: [Cell.btnAddScore,Cell.btnScoreBoard], withBackgroundColor: .getCustomBlueColor())
                
                if IDDefaults.value(forKey: "\(gameID)_Rounds") != nil
                {
                    let roundValue = IDDefaults.value(forKey: "\(gameID)_Rounds")
                    
                    lblRound.text = "Round Completed : \(String(describing: roundValue!))"
                }
                else
                {
                    lblRound.text = " "
                }

            }
            else
            {
                if RoundStatusArray.indices.contains(indexPath.row)
                {
                    if RoundStatusArray[indexPath.row] == "NO"
                    {
                        CommonObjectClass().EnableButtons(buttons: [Cell.btnAddScore,Cell.btnScoreBoard], withBackgroundColor: .getCustomBlueColor())
                        
                    }
                    else if RoundStatusArray[indexPath.row] == "YES"
                    {
                        CommonObjectClass().DisableButtons(buttons: [Cell.btnAddScore], withBackgroundColor: .clear)
                        CommonObjectClass().EnableButtons(buttons: [Cell.btnScoreBoard], withBackgroundColor: .getCustomBlueColor())
                        
                    }

                    if IDDefaults.value(forKey: "\(gameID)_Rounds") != nil
                    {
                        let roundValue = IDDefaults.value(forKey: "\(gameID)_Rounds")
                        
                        lblRound.text = "Current Round : \(String(describing: roundValue!))"
                    }
                    else
                    {
                        lblRound.text = " "
                    }
                }
 
            }

        }
        else
        {
            CommonObjectClass().EnableButtons(buttons: [Cell.btnAddScore,Cell.btnScoreBoard], withBackgroundColor: .getCustomBlueColor())

        }
        
        
        if playerData.Scores.count > 0
        {
            if playerData.Scores.indices.contains(indexPath.row)
            {
               
                
                let countArray = playerData.Scores[indexPath.row]
                
                let TotalCount = countArray.reduce(0,+)
                let LbltotalStr = lblTotalGamePoints.text!.digits
                let totalInt = Float(LbltotalStr)
                
                if TotalCount <= Int((totalInt!/2))
                {
                    Cell.btnTotal.setTitleColor(UIColor.green, for: .normal)
                    
                }
                else if TotalCount > Int((totalInt!/2)) && TotalCount <= Int((totalInt!/1.5))
                {
                    Cell.btnTotal.setTitleColor(UIColor.yellow, for: .normal)
                }
                else if TotalCount < Int(totalInt!)
                {
                    Cell.btnTotal.setTitleColor(UIColor.red, for: .normal)
                }
                else if TotalCount >= Int(totalInt!) // this is for completed players
                {
                    Cell.vwCompleted.isHidden = false
                    CommonObjectClass().EnableButtons(buttons: [Cell.btnRejoin], withBackgroundColor: .getCustomBlueColor())

                    
                    Cell.btnTotal.setTitleColor(UIColor.red, for: .normal)
                    Cell.btnTotal.backgroundColor = .gray
                    
                    CommonObjectClass().DisableButtons(buttons: [Cell.btnAddScore], withBackgroundColor: .clear)
                    Cell.contentView.bringSubview(toFront: Cell.btnScoreBoard)
                    Cell.layer.borderColor = UIColor.lightGray.cgColor
                    Cell.layer.borderWidth = 1.0

                    Cell.btnName.backgroundColor = UIColor.gray
                    
                    if winnderID.count != 0
                    {
                        Cell.btnRejoin.isHidden = true
                    }
                    else
                    {
                        Cell.btnRejoin.isHidden = false
                    }
                    
                }
                
                Cell.btnTotal.setTitle("\(TotalCount)", for: .normal)
            }
            
        }
        if winnderID.count != 0
        {
            if winnderID == playerData.id
            {
                Cell.vwCompleted.isHidden = false
                Cell.imgWinnerCompleted.image = #imageLiteral(resourceName: "Winner_stamp")
                Cell.btnRejoin.isHidden = true
                Cell.contentView.bringSubview(toFront: Cell.btnScoreBoard)
                CommonObjectClass().DisableButtons(buttons: [btnAddPlayer], withBackgroundColor: .clear)
            }

        }
       
        
        
        
        
        Cell.btnScoreBoard.addTarget(self, action: #selector(btnScoreBoradClicked(sender:)), for: .touchUpInside)
        Cell.btnScoreBoard.tag = Int(playerData.id!)!
        
        Cell.btnAddScore.addTarget(self, action: #selector(btnAddScoreClicked(sender:)), for: .touchUpInside)
        Cell.btnAddScore.tag = Int(playerData.id!)!
        
        Cell.btnRejoin.addTarget(self, action: #selector(btnRejoinClicked(sender:)), for: .touchUpInside)
        Cell.btnRejoin.tag = Int(playerData.id!)!

        return Cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    @objc func btnScoreBoradClicked(sender:UIButton) -> Void
    {
        
        if winnderID == String(describing: sender.tag)
        {
            let gameDetails = self.getScoreBoardOf(gameID: gameID)
            
            let scoreboardArr = gameDetails.scoreBoard as! [classPlayersDict]
            
            let getPlayerScoreDict = scoreboardArr.filter {$0.id == String(describing: sender.tag)}
            if getPlayerScoreDict.count == 0
            {
                let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                if UIDevice.current.userInterfaceIdiom != .pad
                {
                    popOverVC.modalPresentationStyle = .popover
                }
                popOverVC.showOnlySingleButton  = true
                popOverVC.strMessage = "Congrats! You have got deal show"
                // popOverVC.delegate = self
                popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                    popOverVC.dismissAlertPop()
                }
                self.present(popOverVC, animated: true, completion: nil)
            }
            else
            {
                self.performSegue(withIdentifier: "ScoreBoardViewControllerSegue", sender: sender)
            }
            
        }
        else
        {
            self.performSegue(withIdentifier: "ScoreBoardViewControllerSegue", sender: sender)
        }
        
        
        
    }
    @objc func btnAddScoreClicked(sender:UIButton) -> Void
    {
        self.performSegue(withIdentifier: "AddScoreViewControllerSegue", sender: sender)
    }
    
    @objc func btnRejoinClicked(sender:UIButton) -> Void
    {
        /*
        let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
         if UIDevice.current.userInterfaceIdiom != .pad
         {
         popOverVC.modalPresentationStyle = .popover
         }
        popOverVC.showOnlySingleButton = false
       // popOverVC.strMessage = "Do you want to rejoin to this game? Your score will be one point more than highest score among the players."
        popOverVC.strMessage = "Will coming soon in next version"
        popOverVC.onNOClicked = {(noClickedStr) ->() in
            
            
        }
        popOverVC.onYESClicked = { (str) -> () in
     
           // self.playerRejoin(playerID: "\(sender.tag)", ID: self.gameID)
        }
        
        self.present(popOverVC, animated: true, completion: nil)
         */
        
        
        let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
        if UIDevice.current.userInterfaceIdiom != .pad
        {
            popOverVC.modalPresentationStyle = .popover
        }
        popOverVC.showOnlySingleButton  = true
        popOverVC.strMessage = "Will coming soon in next version"
       // popOverVC.delegate = self
        popOverVC.onOKClicked  = {(onOKClciked) -> Void in
            popOverVC.dismissAlertPop()
        }
        self.present(popOverVC, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Helper Methods
    //MARK: -
    
    func getNewGameDetailsWith(ID:String) -> NewGame
    {
        var newGame = NewGame()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                newGame =  results![0]
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return newGame
    }
    
    func getPlayerDetialsUsing(ID:String) -> (players:Players,isExist:Bool)
    {
        var player = Players()
        var isexist = false
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<Players>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Players.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", ID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "Players")
            let predicate = NSPredicate(format: "id == %@", ID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                player =  results![0]
                
                isexist = true
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        return (player,isexist)
        
    }
    
    func checkForDisablePlayers(ScoresArr:[[Int]],playersArray:[PlayersModel]) -> Void
    {
      //  isDisablePlayerChecked = true
        
        if ScoresArr.count > 0
        {
            
            for (index, scoreArr) in ScoresArr.enumerated()
            {
                if playersArray.indices.contains(index)
                {
                    let PlayerID = playersArray[index].id
                    
                    let playerTotalCount = scoreArr.reduce(0,+)
                    let LbltotalStr = lblTotalGamePoints.text!.digits
                    let GameTotalInt = Float(LbltotalStr)
                    
                    if playerTotalCount  >= Int(GameTotalInt!)
                    {
                        // Disable player.
                        self.DisablePlayer(playerID:PlayerID!,ID: gameID)
                        
                    }
                }
  
            }
  
        }
        
        
    }
    
    func DisablePlayer(playerID: String, ID:String) -> Void
    {
        print("Disable Player ID : \(playerID)")
        
        var newGame = NewGame()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                newGame =  results![0]
                
                let runningPlayersArr = newGame.runnigPlayerIDs?.components(separatedBy: ",")
                let filteredArray = runningPlayersArr?.filter {$0 != playerID }
                newGame.runnigPlayerIDs = filteredArray?.joined(separator: ",")
                
                var completedIDArr = Array<String>()
                if newGame.compltedPlayerIDs != nil
                {
                    completedIDArr = (newGame.compltedPlayerIDs?.components(separatedBy: ","))!

                }
                if !(completedIDArr.contains(playerID))
                {
                    completedIDArr.append(playerID)
                }
                
                newGame.compltedPlayerIDs = completedIDArr.joined(separator: ",")
                
                
                do {
                    try managedContext?.save()
                    
                    self.UpdateViewForDisablePlayers()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    func updateWinnerID(playerID: String, ID:String) -> Void
    {
        isDisablePlayerChecked = true
        
        var newGame = NewGame()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                newGame =  results![0]
                
                newGame.winnerID = playerID
                newGame.isCompleted = true
                
                
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
    
    @objc func playerRejoin(playerID: String, ID:String) -> Void
    {
        
        var newGame = NewGame()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<NewGame>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = NewGame.fetchRequest()
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
            
        } else {
            request = NSFetchRequest(entityName: "NewGame")
            let predicate = NSPredicate(format: "gameID == %@", ID)
            request.predicate = predicate
        }
        do {
            
            let results = try managedContext?.fetch(request)
            
            if results?.count != 0
            {
                newGame =  results![0]
                
                var runningPlayersArr = newGame.runnigPlayerIDs?.components(separatedBy: ",")
                if !((runningPlayersArr?.contains(playerID))!)
                {
                    runningPlayersArr?.append(playerID)
                }
                
                newGame.runnigPlayerIDs =  runningPlayersArr?.joined(separator: ",")
                
                
                var completedIDArr = Array<String>()
                if newGame.compltedPlayerIDs != nil
                {
                    completedIDArr = (newGame.compltedPlayerIDs?.components(separatedBy: ","))!
                    
                }
                
                
                if completedIDArr.contains(playerID)
                {
                    let filteredArr = completedIDArr.filter{$0 != playerID }
                    
                    newGame.compltedPlayerIDs = filteredArr.joined(separator: ",")
                    
                }
                else
                {
                    newGame.compltedPlayerIDs = completedIDArr.joined(separator: ",")
                }
                

                
                do {
                    try managedContext?.save()
                    
                    self.UpdateViewForDisablePlayers()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    deinit {
        
        debugLog(object: self)
    }

    //MARK: - Segue Navigation
    //MARK: -
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if segue.identifier == "AddScoreViewControllerSegue"
        {
            let addScoreVC : AddScoreViewController = segue.destination as! AddScoreViewController
            
            
            if let playerID = sender as? UIButton
            {
                addScoreVC.playerID = String(describing: playerID.tag) 
                addScoreVC.gameID = gameID
                
            }
            
        }
        else if segue.identifier == "ScoreBoardViewControllerSegue"
        {
            let ScoreVC : ScoreBoardViewController = segue.destination as! ScoreBoardViewController
            
            if let playerID = sender as? UIButton
            {
                ScoreVC.playerID = String(describing: playerID.tag)
                ScoreVC.gameID = gameID
                
            }
   
        }
        
     }
}
extension NewGameViewController : popUpDelegate
{
    func getOkClicked(str: String) {
           
    }
}
