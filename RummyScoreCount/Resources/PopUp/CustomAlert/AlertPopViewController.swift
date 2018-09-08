//
//  AlertPopViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 11/07/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class AlertPopViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var btnNO: UIButton!
    @IBOutlet weak var btnYES: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    var popUpHeight: CGFloat = 150
    var strMessage = ""
    var showOnlySingleButton = false
    var onYESClicked : ((_ testString:String) ->())?
    var onNOClicked :((_ testSting:String) ->())?
    var onOKClicked :((_ testSting:String) ->())?
    
    var delegate : popUpDelegate?
    
    
    //MARK: Private Properties
    fileprivate let animator = Animator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.borderColor = UIColor.getCustomBlueColor().cgColor
        self.view.layer.borderWidth = 2
        lblMessage.text = strMessage
        
        CommonObjectClass().EnableButtons(buttons: [btnNO,btnYES,btnOK], withBackgroundColor: .getCustomBlueColor())
        
        if showOnlySingleButton
        {
            btnYES.isHidden = true
            btnNO.isHidden = true
            
            btnOK.isHidden = false
        
        }
        else
        {
            btnYES.isHidden = false
            btnNO.isHidden = false
            
            btnOK.isHidden = true
        }
        
        
        let lblHeight = lblMessage.getHeight(forText: strMessage, width:screenWidth-20)
                
        let totalHeight = lblHeight + self.btnNO.frame.height + 40 // 40 = up and down space
        
        if totalHeight > popUpHeight
        {
            popUpHeight = totalHeight
        }
  
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    //MARK: - Button Actions
    //MARK: -
    
    @IBAction func btnNOClicked(_ sender: UIButton)
    {
        
        //using notification
      //  NotificationCenter.default.post(name: .btnNOClicked, object: self)
        onNOClicked?("No Clicked")
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnYESClicked(_ sender: UIButton)
    {
        //Using Call backs...
        onYESClicked?("yes Clicked")
      //  self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnOKClicked(_ sender: UIButton)
    {
        //Using Delegates...
        delegate?.getOkClicked(str: "Ok clicked")
        
        //using Callbacks
        onOKClicked?("OK Clicked")
        
    }
    
    func dismissAlertPop() -> Void
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    //MARK: - UIView Transition Delegate
    //MARK: -
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        self.animator.transitionType = .zoom
        self.animator.size = CGSize(width: screenWidth-20, height: popUpHeight)
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return self.animator
    }

    deinit {
        debugLog(object: self)
    }


}
