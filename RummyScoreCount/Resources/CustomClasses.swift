//
//  CustomClasses.swift
//  RummyScoreCount
//
//  Created by Ganesh on 01/07/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Settings
//MARK: -
class SettingsModel : NSObject,NSCoding
{
    
    var totalPoints : String? = nil
    var dropPoints : String? = nil
    var midDropPoints : String? = nil
    var fullCountPoints  : String? = nil
    
    override init() {
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.totalPoints, forKey: "totalPoints")
        aCoder.encode(self.dropPoints, forKey: "dropPoints")
        aCoder.encode(self.midDropPoints, forKey: "midDropPoints")
        aCoder.encode(self.fullCountPoints, forKey: "fullCountPoints")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.totalPoints =  aDecoder.decodeObject(forKey: "totalPoints") as? String
        self.dropPoints =  aDecoder.decodeObject(forKey: "dropPoints") as? String
        self.midDropPoints =  aDecoder.decodeObject(forKey: "midDropPoints") as? String
        self.fullCountPoints =  aDecoder.decodeObject(forKey: "fullCountPoints") as? String
    }

}





