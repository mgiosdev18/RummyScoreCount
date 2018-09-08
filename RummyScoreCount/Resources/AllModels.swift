//
//  AllModels.swift
//  RummyScoreCount
//
//  Created by Ganesh on 05/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

public class ScoreModule: NSObject,NSCoding
{
    var scoreBoardArr : [classPlayersDict]? = nil
    
    override init() {
        super.init()
        
    }
    

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.scoreBoardArr, forKey: "scoreBoardArr")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        self.scoreBoardArr = aDecoder.decodeObject(forKey: "scoreBoardArr") as? [classPlayersDict]
    }
    
    init(scoreBoardArr:[classPlayersDict]) {
        
        self.scoreBoardArr = scoreBoardArr
        
    }
    
}

public class classPlayersDict :NSObject,NSCoding
{
    
    var id : String?
    var scoreDictArray  : [classPlayerScoresDict]?
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.scoreDictArray, forKey: "scoreDictArray")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.scoreDictArray = aDecoder.decodeObject(forKey: "scoreDictArray") as? [classPlayerScoresDict]
    }
    override init() {
        super.init()
        
    }
    init(id:String,scoreDictArray:[classPlayerScoresDict]) {
        self.id = id
        self.scoreDictArray  = scoreDictArray
        
    }
    
    func toDictionary() -> [String: Any] {
        return ["id": self.id!,"scoreDictArray":self.scoreDictArray!]
    }
    
}

public class classPlayerScoresDict:NSObject,NSCoding
{
    var round = Int()
    var score : String?
    var cards : Array<Int>?
    var isHalfCount : Bool?
    
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.round, forKey: "round")
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.cards!, forKey: "cards")
        aCoder.encode(self.isHalfCount!, forKey: "isHalfCount")
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        self.round = aDecoder.decodeInteger(forKey: "round")
        self.score = aDecoder.decodeObject(forKey: "score") as? String
        self.cards = aDecoder.decodeObject(forKey: "cards") as? Array<Int>
        self.isHalfCount = aDecoder.decodeBool(forKey: "isHalfCount")
        
    }
    
    override init() {
        super.init()
        
    }
    init(round:Int, score:String, cards:Array<Int>,isHalfCount:Bool) {
        
        self.round = round
        self.score = score
        self.cards = cards
        self.isHalfCount = isHalfCount
        
    }
    
    func toDictionary() -> [String: Any] {
        return ["round": self.round, "score": self.score!, "cards":self.cards!,"isHalfCount":self.isHalfCount!]
    }
    
}

