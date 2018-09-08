//
//  SideMenuViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 29/06/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tblMenu: UITableView!
    let menuTitles = ["Home","Continue Games","Completed Games","Settings"]
    let menuImages = [#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "continue"),#imageLiteral(resourceName: "completed"),#imageLiteral(resourceName: "settings")]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.getCustomBlueColor().withAlphaComponent(0.9)
        tblMenu.tableFooterView = UIView()
        tblMenu.backgroundColor = UIColor.clear
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        menuCell.backgroundColor = UIColor.clear
        
        menuCell.textLabel?.text = menuTitles[indexPath.row]
        menuCell.textLabel?.textColor = UIColor.white
        
        menuCell.imageView?.image = menuImages[indexPath.row]
      
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            kConstantObj.SetIntialMainViewController("firstVC") // firstVC is storyboard ID
//        }else if indexPath.row == 1 {
//            kConstantObj.SetIntialMainViewController("secondVC")
//        }else if indexPath.row == 2 {
//            kConstantObj.SetIntialMainViewController("thirdVC")
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let _ = kConstantObj.SetIntialMainViewController("HomeViewController")
            break
        case 1:
            let _ = kConstantObj.SetIntialMainViewController("ContinuousGamesViewController")
            break
        case 2:
            let _ = kConstantObj.SetIntialMainViewController("CompletedGamesViewController")
            break
        case 3:
            let _ = kConstantObj.SetIntialMainViewController("SettingsViewController")
            break
        default:
            let _ = kConstantObj.SetIntialMainViewController("HomeViewController")
            break
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        debugLog(object: self)
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
