//
//  AllScoreBoardViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 25/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class AllScoreBoardViewController: UIViewController {

    var gameID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // let gameDetails = self.getScoreBoardOf(gameID: gameID)
        
      //  let scoreboardArr = gameDetails.scoreBoard as! [classPlayersDict]
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
