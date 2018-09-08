//
//  SettingsViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 30/06/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    var settingsModel = SettingsModel()
    var arrSettingsModel = [SettingsModel]()
    
    var strTotalPoints = "201"
    var strDropPoints = "20"
    var strMidDropPoints = "40"
    var strFullCountPoints = "80"
    
    let arrTitles = ["Enter the total game points :","Enter the Drop points :","Enter the Mid.Drop points :","Enter the full count points :"]
    let arrFiledDefaultTexts = ["201 (Default)","20 (Default)","40 (Default)","80 (Default)"]
    var arrFiledTexts = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIColor.getCustomBlueColor().as1ptImage()
        tblSettings.backgroundColor = UIColor.clear
        tblSettings.tableFooterView = UIView()
        CommonObjectClass().EnableButtons(buttons: [btnSave], withBackgroundColor: .getCustomBlueColor())
        
        // Retrive settings data from Coredata
        
        self.getSettingsAndUpdateFields()
       

    }
    
    //MARK: - Helper method
    //MARK: -
    func ShowSuccessPopup() -> Void
    {
        let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
        popOverVC.modalPresentationStyle = .popover
        popOverVC.showOnlySingleButton  = true
        popOverVC.strMessage = "Updated Successfully"
       // popOverVC.delegate = self
        popOverVC.onOKClicked  = {(onOKClciked) -> Void in
            popOverVC.dismissAlertPop()
        }
        self.present(popOverVC, animated: true, completion: nil)
        
    }
    func getSettingsAndUpdateFields() -> Void
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Settings>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Settings.fetchRequest()
            
        } else {
            request = NSFetchRequest(entityName: "Settings")
            
        }
        do {
            
            let results = try managedContext.fetch(request)
            
            if results.count != 0
            {
                let setting = results[0]

                let settingmodel = setting.settingsData as! SettingsModel
                
                if (settingmodel.totalPoints != nil) && (settingmodel.totalPoints?.count != 0)
                {
                    strTotalPoints = settingmodel.totalPoints!
                    arrFiledTexts.append(settingmodel.totalPoints!)
                    
                }
                else
                {
                    arrFiledTexts.append("")
                    strTotalPoints = ""
                }
                
                if (settingmodel.dropPoints != nil) && (settingmodel.dropPoints?.count != 0)
                {
                    strDropPoints = settingmodel.dropPoints!
                    arrFiledTexts.append(settingmodel.dropPoints!)
                    
                }
                else
                {
                    arrFiledTexts.append("")
                    strDropPoints = ""
                }
                
                if (settingmodel.midDropPoints != nil)  && (settingmodel.midDropPoints?.count != 0)
                {
                    strMidDropPoints = settingmodel.midDropPoints!
                    arrFiledTexts.append(settingmodel.midDropPoints!)
                    
                }
                else
                {
                    arrFiledTexts.append("")
                    strMidDropPoints = ""
                }
                
                if (settingmodel.fullCountPoints != nil) && (settingmodel.fullCountPoints?.count != 0)
                {
                    strFullCountPoints = settingmodel.fullCountPoints!
                    arrFiledTexts.append(settingmodel.fullCountPoints!)
                    
                }
                else
                {
                    arrFiledTexts.append("")
                    strFullCountPoints = ""
                }
                
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func btnMenuClicked(_ sender: UIBarButtonItem)
    {
        sideMenuVC.toggleMenu()
    }
    
    //MARK: UITablView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        settingsCell.backgroundColor = UIColor.clear
        
        settingsCell.lblTitle.text = arrTitles[indexPath.row]
        settingsCell.lblTitle.textColor = UIColor.white
        
       
        if arrFiledTexts.count == 0
        {
            settingsCell.fieldGamePoints.placeholder = arrFiledDefaultTexts[indexPath.row]
            settingsCell.fieldGamePoints.setValue(PlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")
        }
        else
        {
            if arrFiledTexts[indexPath.row].count == 0
            {
                settingsCell.fieldGamePoints.placeholder = arrFiledDefaultTexts[indexPath.row]
                settingsCell.fieldGamePoints.setValue(PlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")
            }
            else
            {
                settingsCell.fieldGamePoints.text = arrFiledTexts[indexPath.row]
            }
            
            
        }
        
        settingsCell.fieldGamePoints.tag = indexPath.row
        settingsCell.fieldGamePoints.delegate = self
        
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Settings>
        if #available(iOS 10.0, OSX 10.12, *) {
            request = Settings.fetchRequest()
            
        } else {
            request = NSFetchRequest(entityName: "Settings")
            
        }
        do {
            
            let results = try managedContext.fetch(request)
            
            if results.count == 0
            {
                let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext)!
                
                let addSettings = NSManagedObject(entity: entity, insertInto: managedContext) as! Settings
                
                settingsModel.totalPoints = strTotalPoints
                settingsModel.dropPoints = strDropPoints
                settingsModel.midDropPoints = strMidDropPoints
                settingsModel.fullCountPoints  = strFullCountPoints
                
                addSettings.settingsData = settingsModel
                
                
                do {
                    try managedContext.save()
                    
                    self.ShowSuccessPopup()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
            }
            else
            {
                let settings = results[0]
                
                settingsModel.totalPoints = strTotalPoints
                settingsModel.dropPoints = strDropPoints
                settingsModel.midDropPoints = strMidDropPoints
                settingsModel.fullCountPoints  = strFullCountPoints
                
                settings.settingsData = settingsModel
                
                
                do {
                    try managedContext.save()
                    self.ShowSuccessPopup()
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
            }
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    
    }
    
    //MARK: UITextFiled Delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        switch textField.tag
        {
        case 0:
            print("textFieldDidBeginEditing : \(String(describing: textField.text))")
            strTotalPoints  = textField.text!
            break
        case 1:
            strDropPoints = textField.text!
            break
        case 2:
            strMidDropPoints = textField.text!
            break
        case 3:
            strFullCountPoints = textField.text!
            break
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag
        {
        case 0:
            print("textFieldDidEndEditing : \(String(describing: textField.text))")
            strTotalPoints  = textField.text!
            break
        case 1:
            strDropPoints = textField.text!
            break
        case 2:
            strMidDropPoints = textField.text!
            break
        case 3:
            strFullCountPoints = textField.text!
            break
        default:
            break
        }
    }
    
  
    deinit {
        debugLog(object: self)
    }
    
}

extension SettingsViewController : popUpDelegate
{
    
    func getOkClicked(str: String) {
        
        print("When No Clikced : \(str)")
        
    }
    
}
