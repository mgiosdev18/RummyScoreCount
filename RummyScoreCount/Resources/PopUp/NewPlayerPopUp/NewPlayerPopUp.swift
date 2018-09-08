//
//  NewPlayerPopUp.swift
//  RummyScoreCount
//
//  Created by Ganesh on 03/07/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class NewPlayerPopUp: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var segmentedMaleFemale: UISegmentedControl!
    @IBOutlet weak var fieldPlayerName: UITextField!
    @IBOutlet weak var fieldYOB: UITextField!
    @IBOutlet var fieldColln: [UITextField]!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    var doEdit = false
    var playerID = ""
    
    
    let sampleImgeArr = [#imageLiteral(resourceName: "m1"),#imageLiteral(resourceName: "f1"),#imageLiteral(resourceName: "m4"),#imageLiteral(resourceName: "f3"),#imageLiteral(resourceName: "m2"),#imageLiteral(resourceName: "f4"),#imageLiteral(resourceName: "f2"),#imageLiteral(resourceName: "m3")]
    var imgPicker = UIImagePickerController()
    
    var strMaleFemale = ""
    var strPlayerName = ""
    var strYOB = ""
    var isShowed = false
    
    
    var bgView = UIView()
    
    var canDismissView = false
    
    
  //  weak var Observer : NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)

      //  CommonObjectClass().showAnimate(FromVC: self)
       
        btnEditProfile.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        CommonObjectClass().EnableButtons(buttons: [btnCancel,btnSave], withBackgroundColor: .getCustomBlueColor())
        imgPicker.delegate = self
        
        self.errorLabelAppearance()
        self.textFieldAppearance()
        self.segmentedAppearance()
        let RandomNumber = Int(arc4random_uniform(UInt32(self.sampleImgeArr.count)))
        self.imgProfile.image = sampleImgeArr[RandomNumber]
        
        
        // Notification : OLD method
       // NotificationCenter.default.addObserver(self, selector: #selector(handleOKClicked), name: .btnOKClicked, object: nil)
        
        //Notificaation : NEW Method

        
//        Observer =  NotificationCenter.default.addObserver(forName: .btnNOClicked, object: nil, queue: OperationQueue.main) { (notification) in
//
//            let popp  = notification.object as! AlertPopViewController
//            self.btnEditProfile.setTitle(popp.strMessage, for: .normal)
//
//            print("No observer clicked")
//
//        }
   
        
        
    }
    

    
    /* Notification OLD Method
    @objc func handleOKClicked(notification: Notification)
    {
        let alertVC = notification.object as! AlertPopViewController
        
        print(alertVC.strMessage)
        
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if doEdit
        {
            if !isShowed
            {
                isShowed = true
                
                let player = self.getPlayer(ofID: playerID)
                
                imgProfile.image = UIImage(data: player.avatar!)
                fieldPlayerName.text = player.name
                strPlayerName = player.name!
                fieldYOB.text = player.yearOfBirth
                strYOB = player.yearOfBirth!
                
                if player.gender == "Male"
                {
                    segmentedMaleFemale.selectedSegmentIndex = 0
                    strMaleFemale = "Male"
                }
                else
                {
                    segmentedMaleFemale.selectedSegmentIndex = 1
                    strMaleFemale = "Female"
                }
            }
            
         
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        if canDismissView
        {
            self.btnCancelClicked(btnCancel)
            canDismissView = !canDismissView
        }
        
      
        
    }
    
    override func viewDidLayoutSubviews() {
        
        self.profileImageAppearance()
    
        
    }
    //MARK: - All Actions
    //MARK: - 
    @IBAction func btnEditClicked(_ sender: UIButton)
    {
        let actionSheet : UIAlertController  = UIAlertController(title: nil, message: "Select the source from where you want to upload the picture", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraActionClicked) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.imgPicker.sourceType = .camera
                self.present(self.imgPicker, animated: true, completion: nil)
            }
            else
            {
                let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                popOverVC.modalPresentationStyle = .popover
                popOverVC.showOnlySingleButton  = true
                popOverVC.strMessage = "Camera not available in your device"
               // popOverVC.delegate = self
                popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                    popOverVC.dismissAlertPop()
                }
                self.present(popOverVC, animated: true, completion: nil)
                
            }
            
            
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (galleryActionClicked) in
            self.imgPicker.sourceType = .photoLibrary
            self.present(self.imgPicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (cancelActionClicked) in
            
            self.imgPicker.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    @IBAction func SegmentedMaleFemaleClicked(_ sender: UISegmentedControl)
    {
        lblError.isHidden = true
        
        switch sender.selectedSegmentIndex {
        case 0:
            strMaleFemale = "Male"
            break
        case 1:
            strMaleFemale = "Female"
            break
        default:
            break
        }
        
    }
    @IBAction func btnCancelClicked(_ sender: UIButton)
    {
        //CommonObjectClass().removeAnimate(FromVC: self)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
    
        let checkFields = self.CheckForFields()
        
        if checkFields.Status == true
        {
            lblError.isHidden = true
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            
            if doEdit
            {
                let editPlayer = self.getPlayer(ofID: playerID)
                
                editPlayer.avatar = UIImagePNGRepresentation((imgProfile.image?.fixedOrientation())!)
                editPlayer.gender = strMaleFemale
                editPlayer.name  =  strPlayerName
                editPlayer.yearOfBirth = strYOB
                
                do {
                    try managedContext.save()
                    
                    let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                    popOverVC.modalPresentationStyle = .popover
                    popOverVC.showOnlySingleButton  = true
                    popOverVC.strMessage = "Player updated successfully."
                    // popOverVC.delegate = self
                    popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                        popOverVC.dismissAlertPop()
                        self.canDismissView = !self.canDismissView
                    }
                    self.present(popOverVC, animated: true, completion: nil)
                    
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
                
                
            }
            else
            {
           
                
                let entity = NSEntityDescription.entity(forEntityName: "Players", in: managedContext)!
                
                let addPlayer = NSManagedObject(entity: entity, insertInto: managedContext) as! Players
                
                addPlayer.id = CommonObjectClass().AddNewIDFor(key: newGameID)
                addPlayer.avatar = UIImagePNGRepresentation((imgProfile.image?.fixedOrientation())!)
                addPlayer.gender = strMaleFemale
                addPlayer.name  =  strPlayerName
                addPlayer.yearOfBirth = strYOB
                
                
                do {
                    try managedContext.save()
                    
                    if self.GetPlayersCount() == MaxPlayers
                    {
                        
                        let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
                        popOverVC.modalPresentationStyle = .popover
                        popOverVC.showOnlySingleButton  = true
                        popOverVC.strMessage = "Player added successfully.\nYou have added maximum of \(MaxPlayers) players"
                        // popOverVC.delegate = self
                        popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                            popOverVC.dismissAlertPop()
                            self.canDismissView = !self.canDismissView
                        }
                        self.present(popOverVC, animated: true, completion: nil)
                    }
                    else
                    {
                        
                        self.showAddAnotherPlayerPop()
                        
                    }
                    
                    
                } catch let error as NSError {
                    print("Count't save..\(error.description)")
                    
                }
            }
        
     
        }
        else
        {
            lblError.isHidden = false
            lblError.text = checkFields.Message
        }
        

    }

    
    //MARK: - UIImagePickerController Delegate
    //MARK: -

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        imgProfile.image = info[UIImagePickerControllerOriginalImage]  as? UIImage
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Picker cancel")
    }
    
    //MARK: - UITextField Delegate
    //MARK: -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.lblError.isHidden = true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    //MARK: - Appearance Methods
    //MARK: -
    func profileImageAppearance() -> Void
    {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.clipsToBounds = true
    }
    
    func segmentedAppearance() -> Void
    {
        segmentedMaleFemale.tintColor = UIColor.getCustomBlueColor()
        segmentedMaleFemale.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .selected)
        segmentedMaleFemale.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)], for: .normal)
       // strMaleFemale = segmentedMaleFemale.titleForSegment(at: 0)!
        segmentedMaleFemale.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    func textFieldAppearance() -> Void
    {
        for tField in fieldColln
        {
            tField.layer.borderColor = UIColor.getCustomBlueColor().cgColor
            tField.layer.borderWidth = 1
            tField.setValue(PlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")
            
        }
        
    }
   
    func errorLabelAppearance() -> Void
    {
        lblError.layer.cornerRadius = 10
        lblError.clipsToBounds = true
        lblError.isHidden = true
    }
    
    // MARK: - Helper Methods
    // MARK: -
    func getPlayer(ofID:String) -> Players
    {

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
    
    func ClearDataForAddNewPlayer() -> Void
    {
        self.strMaleFemale = ""
        self.strYOB = ""
        self.strPlayerName = ""
        let RandomNumber = Int(arc4random_uniform(UInt32(self.sampleImgeArr.count)))
        self.imgProfile.image = sampleImgeArr[RandomNumber]
        self.segmentedMaleFemale.selectedSegmentIndex = UISegmentedControlNoSegment
        self.fieldPlayerName.text = ""
        self.fieldYOB.text = ""
    }
    
    func showAddAnotherPlayerPop() -> Void
    {
        
            let popOverVC = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "AlertPopViewController") as! AlertPopViewController
            popOverVC.modalPresentationStyle = .popover
            popOverVC.showOnlySingleButton = false
            popOverVC.strMessage = "Player added successfully.\nDo you want to add another player?"
            popOverVC.onNOClicked = {(noClickedStr) ->() in
                popOverVC.dismissAlertPop()
                self.canDismissView = !self.canDismissView
                
                
            }
            popOverVC.onYESClicked = { (str) -> () in
                
                print("strrr ; \(str)")
                popOverVC.dismissAlertPop()
                
                self.ClearDataForAddNewPlayer()
            }
           // popOverVC.delegate = self
            popOverVC.onOKClicked  = {(onOKClciked) -> Void in
                popOverVC.dismissAlertPop()
            }
            self.present(popOverVC, animated: true, completion: nil)
            
       
        
    }
    
    func CheckForFields() -> (Status: Bool, Message:String)
    {
        var message = ""
        strPlayerName = fieldPlayerName.text!
        strYOB = fieldYOB.text!
        
        if strMaleFemale != "" && strPlayerName != ""
        {
            message = "Success"
            return (true,message)
        }
        else
        {
            if strMaleFemale == ""
            {
                message = "Please select gender"
                
            }
            else
            {
                message = "Please enter player name"
            }
            
            
            return (false,message)
        }
    }
    
    func showAnimate()
    {
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
        self.navigationController?.isNavigationBarHidden = false
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
    
    
    
    
    deinit {
        debugLog(object: self)
    }

}


//MARK: - Using Delegation Methods Getting data from pop up

extension NewPlayerPopUp : popUpDelegate
{
    func getOkClicked(str: String) {
        
        print("when OK Clikced : \(str)")
         self.canDismissView = !self.canDismissView

    }
    
    
}
