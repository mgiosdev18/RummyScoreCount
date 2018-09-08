//
//  HomeViewController.swift
//  RummyScoreCount
//
//  Created by Ganesh on 29/06/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    

    @IBOutlet weak var btnStartNewGame: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    //    let forcePortrait = UIInterfaceOrientation.portrait.rawValue
    //    UIDevice.current.setValue(forcePortrait, forKey: "orientation")
        
        self.addTitleLogoToNavBar()
        CommonObjectClass().EnableButtons(buttons: [btnStartNewGame], withBackgroundColor: .getCustomBlueColor())
       
        
    }
    //MARK : Helper Methods...
    
    func addTitleLogoToNavBar() -> Void
    {
        let image : UIImage = UIImage(named: "Logo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.shadowImage = UIColor.getCustomBlueColor().as1ptImage()
        
    }

    @IBAction func btnStartNewGameClicked(_ sender: UIButton)
    {
     

    }
    
   /*
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }
    override var shouldAutorotate: Bool
    {
        return false
    }
 */
    @IBAction func btnSideMenuClicked(_ sender: UIBarButtonItem)
    {
        sideMenuVC.toggleMenu()
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
