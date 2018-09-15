//
//  AddScoreViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 03/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class AddScoreViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var lblselectCardMessage: UILabel!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTotalPoints: UILabel!
    @IBOutlet weak var lblHalfCount: UILabel!
    
    var playerID = String()
    var gameID = String()
    
    let numberOfCellsInRow: CGFloat = 4
    let arrCardsImages = [#imageLiteral(resourceName: "letter-a"),#imageLiteral(resourceName: "letter-j"),#imageLiteral(resourceName: "letter-q"),#imageLiteral(resourceName: "letter-k"),#imageLiteral(resourceName: "two"),#imageLiteral(resourceName: "three"),#imageLiteral(resourceName: "four"),#imageLiteral(resourceName: "five"),#imageLiteral(resourceName: "six"),#imageLiteral(resourceName: "seven"),#imageLiteral(resourceName: "eight"),#imageLiteral(resourceName: "nine"),#imageLiteral(resourceName: "ten")]
    var arrcardsCount = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    var totalCardCount = 0
    var arrNumberOfCardsCount = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    var systemCount = 0
    var isSelectedSystemCount = false
    var isHalfCount = false
    
    var strRummy = 0
    var strDrop = Int()
    var strMidDrop = Int()
    var strFullCount = Int()
    var arrPlayerScores = Array<classPlayersDict>()
    var gameTotal = ""
    var CurrentPopUpMessage = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingPoints = CommonObjectClass().GetSettingsData()
        
        gameTotal = settingPoints.totalPoints

        // Do any additional setup after loading the view.
        lblselectCardMessage.text = "OR\nselect cards to get your score. No need to select Wild/Paper jocker."
        cardsCollectionView.backgroundColor = .clear
        CommonObjectClass().EnableButtons(buttons: [btnDone], withBackgroundColor: UIColor.getCustomBlueColor())
        self.segmentedAppearance()
        self.updateTotalPointsLable()
        
        self.btnCheckBox.isEnabled = false
        self.isHalfCount = false
        self.btnCheckBox.isSelected = false
        self.btnCheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
        self.lblHalfCount.textColor = UIColor.white.withAlphaComponent(0.5)
        
        
        
        strDrop = Int(settingPoints.drop)!
        strMidDrop = Int(settingPoints.midDrop)!
        strFullCount = Int(settingPoints.fullCount)!
        
        
    }
    
    @IBAction func segmentButtonsClicked(_ sender: UISegmentedControl)
    {
        isSelectedSystemCount = true
        
        self.btnCheckBox.isEnabled = false
        isHalfCount = false
        self.btnCheckBox.isSelected = false
        self.btnCheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
        self.lblHalfCount.textColor = UIColor.white.withAlphaComponent(0.5)
        
        switch sender.selectedSegmentIndex {
        case 0:
            systemCount = strRummy
            break
        case 1:
            systemCount = strDrop
            break
        case 2:
            systemCount = strMidDrop
            break
        case 3:
            systemCount = strFullCount
            break
        default: break
            
        }
        
        updateTotalPointsLable()
        
    }
    
    @IBAction func btnCheckBoxClicked(_ sender: UIButton)
    {
        self.btnCheckBox = sender
 
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected
        {
            
            let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
            if UIDevice.current.userInterfaceIdiom != .pad
            {
                popOverVC.modalPresentationStyle = .popover
            }
            popOverVC.showOnlySingleButton = false
            popOverVC.strMessage = "Are you confirm that you are not played yet for this round. If so your score will be half of your total count for this round"
            popOverVC.onNOClicked = {(noClickedStr) ->() in
                popOverVC.dismissAlertPop()
                sender.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
                self.isHalfCount = false
                sender.isSelected = false
                
            }
            popOverVC.onYESClicked = { (str) -> () in
                popOverVC.dismissAlertPop()
                sender.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
                self.isHalfCount = true
                sender.isSelected = true
                
                self.updateTotalPointsLable()
            }
            
            self.present(popOverVC, animated: true, completion: nil)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
            isHalfCount = false
            self.updateTotalPointsLable()
        }
  
        
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton)
    {
        
        let currentGameData = self.getScoreBoardOf(gameID: "\(gameID)")
        
        if currentGameData.scoreBoard == nil
        {
            //get the player round scores including cards
  
            let playerRoundScore = classPlayerScoresDict.init(round: 1, score: self.lblTotalPoints.text!, cards: arrcardsCount,isHalfCount:self.isHalfCount)
            
            
            if IDDefaults.value(forKey: "\(gameID)_Rounds") == nil
            {
                IDDefaults.set(1, forKey: "\(gameID)_Rounds")
            }

            
            //add this score to player id
            let player = classPlayersDict.init(id: playerID, scoreDictArray: [playerRoundScore])
            
            //  arrPlayerScores.append(player)
            
            self.addScoresOf(gameID: "\(gameID)", PlayerID: playerID, withScores: [player])
        }
        else
        {
            let scoresArray = currentGameData.scoreBoard as! [classPlayersDict]

            let filterdArr = scoresArray.filter {$0.id == playerID}
            
            if filterdArr.count == 0
            {
                var arrTotalRoundsDict = Array<classPlayersDict>()
                for playerDictArr in scoresArray
                {
                    arrTotalRoundsDict.append(playerDictArr)
                    
                }
            
                
                let playerRoundScore = classPlayerScoresDict.init(round: 1 , score: self.lblTotalPoints.text!, cards: arrcardsCount,isHalfCount:self.isHalfCount)
   

               // IDDefaults.set(1, forKey: "\(gameID)_Rounds")
          
                
                //add this score to player id
                let player = classPlayersDict.init(id: playerID, scoreDictArray: [playerRoundScore])
                
                  arrTotalRoundsDict.append(player)
                
                self.addScoresOf(gameID: "\(gameID)", PlayerID: playerID, withScores: arrTotalRoundsDict)
            }
            else
            {
                var arrTotalRoundsDict = Array<classPlayersDict>()
                
                for playerDictArr in scoresArray
                {
                    if playerDictArr.id == playerID
                    {
                        
                        let playerDictArr = filterdArr.first
                        
                        var scoreDictArr = playerDictArr?.scoreDictArray
                        
                        let nextRoundValue = (scoreDictArr?.map {$0.round}.max())! + 1

//                         IDDefaults.set(nextRoundValue, forKey: "\(gameID)_Rounds")
                        
                        let playerRoundScore = classPlayerScoresDict.init(round: nextRoundValue, score: self.lblTotalPoints.text!, cards: arrcardsCount,isHalfCount:self.isHalfCount)
                        
                        scoreDictArr?.append(playerRoundScore)
                        
                        //add this score to player id
                        let player = classPlayersDict.init(id: playerID, scoreDictArray: scoreDictArr!)
                        
                        arrTotalRoundsDict.append(player)
                    }
                    else
                    {
                        arrTotalRoundsDict.append(playerDictArr)
                    }
                    
              
                    
                }
                
                
            
                
                self.addScoresOf(gameID: "\(gameID)", PlayerID: playerID, withScores:arrTotalRoundsDict)
                
                
                
            }
            
     
            /*
            for playerDict in scoresArray
            {
                if playerDict.id == playerID
                {
                    arrPlayerScores.append(playerDict)
                    
                    var scoresarray = playerDict.scoreDictArray
                    
                    scoresarray?.append(newScoreDict!)
                    
                }
            }
            */
            
            
        }
        

        
    }
    
    
    
    //MARK: - UICollectionView Delegate methods
    //MARK: -
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrCardsImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddScoreCollectionViewCell", for: indexPath) as! AddScoreCollectionViewCell
        
       // let playerData = arrSelectedPlayers[indexPath.row]
        
        Cell.backgroundColor = .clear
        Cell.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        Cell.layer.borderWidth = 1.0
        Cell.layer.cornerRadius = 5
        Cell.clipsToBounds = true
        
        Cell.lblCardsCount.backgroundColor = .clear
        Cell.imgCard.image = arrCardsImages[indexPath.row]
        
        Cell.btnIncrement.addTarget(self, action: #selector(btnCardIncreseClicked(sender:)), for: .touchUpInside)
        Cell.btnIncrement.tag = indexPath.row
        
        Cell.btnDecrement.addTarget(self, action: #selector(btnCardDecreseClicked(sender:)), for: .touchUpInside)
        Cell.btnDecrement.tag = indexPath.row
        
        Cell.lblCardsCount.text = String(describing: arrcardsCount[indexPath.row])
        
        if arrcardsCount[indexPath.row] > 0
        {
            Cell.backgroundColor = UIColor.getCustomBlueColor()
        }
        else
        {
            Cell.backgroundColor = .clear
        }
        
        
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth : CGFloat = cardsCollectionView.frame.size.width / numberOfCellsInRow
        let cellheight : CGFloat = (cardsCollectionView.frame.size.width + 100 ) / numberOfCellsInRow
        let cellSize = CGSize(width: cellWidth-10 , height:cellheight-10)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    @objc func btnCardIncreseClicked(sender:UIButton) -> Void
    {
       // print("you incremented \(sender.tag+1)")

        if isSelectedSystemCount
        {
            self.btnCheckBox.isEnabled = true
            self.lblHalfCount.textColor = UIColor.white
            
            isSelectedSystemCount = false
            systemCount = 0
            segmentView.selectedSegmentIndex = UISegmentedControlNoSegment
            
            if arrcardsCount[sender.tag] >= 0
            {
                arrcardsCount[sender.tag] = arrcardsCount[sender.tag] + 1
                self.updateTotalPointsLable()
                cardsCollectionView.reloadData()
            }
        }
        else
        {
            if totalCardCount < Int(strFullCount)
            {
                self.btnCheckBox.isEnabled = true
                self.lblHalfCount.textColor = UIColor.white
                isSelectedSystemCount = false
                systemCount = 0
                segmentView.selectedSegmentIndex = UISegmentedControlNoSegment
                
                if arrcardsCount[sender.tag] >= 0
                {
                    arrcardsCount[sender.tag] = arrcardsCount[sender.tag] + 1
                    self.updateTotalPointsLable()
                    cardsCollectionView.reloadData()
                }
            }
            else
            {
                
                let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                if UIDevice.current.userInterfaceIdiom != .pad
                {
                    popOverVC.modalPresentationStyle = .popover
                }
                popOverVC.showOnlySingleButton  = true
                popOverVC.strMessage = "You cannot add more than full count, please check your score once."
                CurrentPopUpMessage = "You cannot add more than full count, please check your score once."
               // popOverVC.delegate = self
                popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                    popOverVC.dismissAlertPop()
                }
                self.present(popOverVC, animated: true, completion: nil)
                
            }
            
        }
        
  
        
    }
    @objc func btnCardDecreseClicked(sender:UIButton) -> Void
    {
      //  print("you decremnted \(sender.tag+1)")
        if arrcardsCount[sender.tag] > 0
        {
            arrcardsCount[sender.tag] = arrcardsCount[sender.tag] - 1
            self.updateTotalPointsLable()
            cardsCollectionView.reloadData()
        }
        
    }
    
    //MARK: - Helper Methods
    //MARK: -
    
    func segmentedAppearance() -> Void
    {
        segmentView.tintColor = UIColor.getCustomBlueColor()
        segmentView.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .selected)
        segmentView.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        segmentView.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    func updateTotalPointsLable() -> Void
    {
        lblTotalPoints.layer.cornerRadius = 10
        lblTotalPoints.clipsToBounds = true
        
        if isSelectedSystemCount
        {
            
            if arrNumberOfCardsCount.reduce(0, +) > 0
            {
                print("Show pop up for losting selected cards")
                
                let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                if UIDevice.current.userInterfaceIdiom != .pad
                {
                    popOverVC.modalPresentationStyle = .popover
                }
                popOverVC.showOnlySingleButton = false
                popOverVC.strMessage = "Selected cards will be removed from your count,do you want to continue?"
                popOverVC.onNOClicked = {(noClickedStr) ->() in
                    popOverVC.dismissAlertPop()
                    self.isSelectedSystemCount = false
                    self.systemCount = 0
                    self.segmentView.selectedSegmentIndex = UISegmentedControlNoSegment
                    
                    self.btnCheckBox.isEnabled = true
                    if self.isHalfCount
                    {
                        self.btnCheckBox.isSelected = true
                        self.btnCheckBox.setImage(#imageLiteral(resourceName: "CheckedBox"), for: .normal)
                    }
                    else
                    {
                        self.btnCheckBox.isSelected = false
                        self.btnCheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
                    }
                    self.lblHalfCount.textColor = UIColor.white
                    
                }
                popOverVC.onYESClicked = { (str) -> () in
                    popOverVC.dismissAlertPop()
                    self.arrcardsCount = [0,0,0,0,0,0,0,0,0,0,0,0,0]
                    self.arrNumberOfCardsCount = [0,0,0,0,0,0,0,0,0,0,0,0,0,]
                    self.totalCardCount = self.systemCount
                    
                    self.cardsCollectionView.reloadData()
                    self.lblHeading.text = "Ganesh, Your total points for this round is :"
                    
                    
                    if self.totalCardCount > Int(self.gameTotal)!
                    {
                        self.lblTotalPoints.text = self.gameTotal
                    }
                    else
                    {
                        self.lblTotalPoints.text = "\(self.totalCardCount)"
                    }
                }
                
                self.present(popOverVC, animated: true, completion: nil)
                
            }
            else
            {
                arrNumberOfCardsCount = [0,0,0,0,0,0,0,0,0,0,0,0,0,]
                totalCardCount = systemCount
            }
      
            
        }
        else
        {
            for (index,element) in arrcardsCount.enumerated()
            {
                var numberCount = 0
                
                if index == 0 || index == 1 || index == 2 || index == 3
                {
                    numberCount = element * 10
                    
                    arrNumberOfCardsCount[index] = numberCount
                    
                }
                else
                {
                    numberCount = element * (index - 2)
                    arrNumberOfCardsCount[index] = numberCount
                }
            
            }
            
            totalCardCount = arrNumberOfCardsCount.reduce(0, +)
        }
        
       // print("totalCardCount :\(totalCardCount)")
        
        self.lblHeading.text = "Your total points for this round is :"
        if totalCardCount > Int(gameTotal)!
        {
            self.lblTotalPoints.text = gameTotal
        }
        else
        {
            if isHalfCount
            {
                let halfHount = totalCardCount/2
                
                if halfHount >= 2
                {
                     self.lblTotalPoints.text = "\(halfHount)"
                }
                else
                {
                    if totalCardCount == 0
                    {
                        self.lblTotalPoints.text = "\(0)"
                    }
                    else
                    {
                        self.lblTotalPoints.text = "\(2)"
                    }
                    
                }
               
            }
            else
            {
                self.lblTotalPoints.text = "\(totalCardCount)"
            }
            
        }
        
        self.lblTotalPoints.backgroundColor = UIColor.getCustomBlueColor()
        
        if totalCardCount == 0
        {
            self.btnCheckBox.isEnabled = false
            self.isHalfCount = false
            self.btnCheckBox.isSelected = false
            self.btnCheckBox.setImage(#imageLiteral(resourceName: "UnCheckedBox"), for: .normal)
            self.lblHalfCount.textColor = UIColor.white.withAlphaComponent(0.5)
        }
        
    }

    
    func addScoresOf(gameID:String,PlayerID:String , withScores:[classPlayersDict]) -> Void
    {
       // var newGame = NewGame()
        
      //  let newScoreDict = withScores.scoreDictArray?.first
        
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
               // let scoresArray = [withScores]
                
                /*
                for playerDict in scoresArray
                {
                    if playerDict.id == playerID
                    {
                        arrPlayerScores.append(playerDict)
                        
                        var scoresarray = playerDict.scoreDictArray
                        
                        scoresarray?.append(newScoreDict!)
                        
                    }
                }
                 */
                
                results?.first?.scoreBoard = withScores as NSObject
                
                do
                {
                    try managedContext?.save()
                    print("Score board saved")
                    
                    let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                    if UIDevice.current.userInterfaceIdiom != .pad
                    {
                        popOverVC.modalPresentationStyle = .popover
                    }
                    popOverVC.showOnlySingleButton  = true
                    popOverVC.strMessage = "Score added successfully"
                   // popOverVC.delegate = self
                    popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                        popOverVC.dismissAlertPop()
                        if self.CurrentPopUpMessage == "You cannot add more than full count, please check your score once."
                        {
                            self.CurrentPopUpMessage = ""
                        }
                        else
                        {
                            self.popToView()
                        }
                        
                    }
                    self.present(popOverVC, animated: true, completion: nil)
                    
                    
                } catch let error as NSError
                {
                    print("score board save error : \(error.description)")
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
       // return newGame
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
    
    func popToView() {
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    deinit {
        debugLog(object: self)
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

extension AddScoreViewController : popUpDelegate
{
    func getOkClicked(str: String) {
        if CurrentPopUpMessage == "You cannot add more than full count, please check your score once."
        {
            CurrentPopUpMessage = ""
        }
        else
        {
            self.popToView()
        }
        
        
    }
}
