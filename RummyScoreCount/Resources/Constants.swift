//
//  Constants.swift
//  ARCHIDPLY
//
//  Created by Ganesh on 26/04/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import Foundation
import UIKit

#if swift(>=4.2)
import UIKit.UIGeometry
extension UIEdgeInsets {
    public static let zero = UIEdgeInsets()
}
#endif
public func debugLog(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    print("\(className) : De-Allocated from memory")
    #endif
}

// Current Screeen sizes
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
let PlaceHolderColor = UIColor.white.withAlphaComponent(0.6)

let newPlayerID = "newPlayerID"
let newGameID = "newGameID"
let MaxPlayers = 5

let IDDefaults = UserDefaults.standard

