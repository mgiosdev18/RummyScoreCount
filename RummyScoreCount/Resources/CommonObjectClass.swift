//  CommonObjectClass.swift
//  ARCHIDPLY
//
//  Created by Ganesh on 26/04/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit
import CoreData

class CommonObjectClass: NSObject {
    
    let bgView  = UIView()
    
    func pushTheView(fromVC:UIViewController, toVC:UIViewController, withIdentifier:String) -> Void
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toView = storyBoard.instantiateViewController(withIdentifier: withIdentifier) 
        fromVC.navigationController?.pushViewController(toView, animated: true)
 
    }
    
    func DisableButtons(buttons: [UIButton], withBackgroundColor: UIColor) -> Void {
        
        for btn in buttons {
            
            btn.backgroundColor = withBackgroundColor
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.getCustomGreyColor().cgColor
            btn.isUserInteractionEnabled = false
            btn.setTitleColor(UIColor.getCustomGreyColor(), for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
        }
        
        
    }
    
    func EnableButtons(buttons: [UIButton] , withBackgroundColor: UIColor)  -> Void {
        
        for btn in buttons
        {
            btn .backgroundColor = withBackgroundColor
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.white.cgColor
            btn.isUserInteractionEnabled = true
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
        }
        
    }
    
  
    func currentdatetime() -> String {
        let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = NSTimeZone.local
        return "\( dateFormatter.string(from: NSDate() as Date))"
    }
    func showBGView(bgView:UIView, OnVC:UIViewController)
    {

        bgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        bgView.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            bgView.alpha = 1.0
            bgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            OnVC.view.addSubview(bgView)
        });
        
    }
    func removeBGView(bgView:UIView,FromVC:UIViewController)
    {

        
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        UIView.animate(withDuration: 0.25, animations: {
            bgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            bgView.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                bgView.removeFromSuperview()
            }
        });
    }

    func showAnimate(FromVC:UIViewController)
    {
        FromVC.navigationController?.isNavigationBarHidden = true
        
        FromVC.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        FromVC.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            FromVC.view.alpha = 1.0
            FromVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
    }
    
    func removeAnimate(FromVC:UIViewController)
    {
        UIView.animate(withDuration: 0.25, animations: {
            FromVC.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            FromVC.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                FromVC.view.removeFromSuperview()
            }
        });
        FromVC.navigationController?.isNavigationBarHidden = false
    }
    
    func createUserID() -> Int64 {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int64(since1970 * 1000)
    }
    
    func AddNewIDFor(key:String) -> String
    {
        
        var newIDStr = String()
        var newIDInt: Int = 0
        

    //    if key == newPlayerID
    //    {
            if IDDefaults.value(forKey: key) == nil
            {
                newIDStr = String(describing: newIDInt)
                IDDefaults.set(newIDInt, forKey: key)
                
            }
            else
            {
                newIDInt = ((IDDefaults.value(forKey: key)as! Int) + 1)
                newIDStr = String(describing: newIDInt)
                IDDefaults.set(newIDInt, forKey: key)
  
  
            }
        
        print("\(key) : \(newIDStr)")
        
    //    }
//        else if key == newGameID
//        {
//            if IDDefaults.value(forKey: key) == nil
//            {
//                newIDStr = String(describing: newIDInt)
//
//            }
//            else
//            {
//                newIDInt = ((IDDefaults.value(forKey: key)as! Int) + 1)
//
//                newIDStr = String(describing: newIDInt)
//
//
//            }
//        }
        
        return newIDStr
    }

    //MARK: - Getting Game total
    //MARK: -
    func GetSettingsData() -> (totalPoints:String, drop:String, midDrop:String, fullCount:String)
    {
        
        var strTotalPoints = "201"
        var strDrop = "20"
        var strMidDrop = "40"
        var strFullCount = "80"
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return (strTotalPoints,strDrop,strMidDrop,strFullCount)
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
                    
                }
                
                if (settingmodel.dropPoints != nil) && (settingmodel.dropPoints?.count != 0)
                {
                    strDrop = settingmodel.dropPoints!
                    
                }
                
                if (settingmodel.midDropPoints != nil)  && (settingmodel.midDropPoints?.count != 0)
                {
                    strMidDrop = settingmodel.midDropPoints!
                    
                }
                
                if (settingmodel.fullCountPoints != nil) && (settingmodel.fullCountPoints?.count != 0)
                {
                    strFullCount = settingmodel.fullCountPoints!
                    
                }
            }
            
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return (strTotalPoints,strDrop,strMidDrop,strFullCount)
    }
}
