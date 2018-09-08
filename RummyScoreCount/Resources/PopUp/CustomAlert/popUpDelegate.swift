//
//  popUpDelegate.swift
//  RummyScoreCount
//
//  Created by Ganesh on 19/07/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import Foundation

@objc protocol popUpDelegate {

    func getOkClicked(str:String)
    
    @objc optional func dismissAlert()
}
