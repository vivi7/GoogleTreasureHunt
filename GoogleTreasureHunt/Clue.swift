//
//  Clue.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

class Clue : NSObject, NSCoding {
    
    
    var type:String!
    var id:String!
    var shufflegroup:Int!
    var displayName:String!
    var displayText:String!
    var displayImage:String!
    var tags:[AHTag] = []
    var question:TriviaQuestion?
    
    override init() {
        
    }
    
    internal required init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObjectForKey("ktype") as! String
        self.id = aDecoder.decodeObjectForKey("kid") as! String
        self.shufflegroup = aDecoder.decodeObjectForKey("kshufflegroup") as! Int
        self.displayName = aDecoder.decodeObjectForKey("kdisplayName") as! String
        self.displayText = aDecoder.decodeObjectForKey("kdisplayText") as! String
        self.displayImage = aDecoder.decodeObjectForKey("kdisplayImage") as! String
        self.tags = aDecoder.decodeObjectForKey("ktags") as! [AHTag]
        self.question = aDecoder.decodeObjectForKey("kquestion") as? TriviaQuestion
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.type, forKey: "ktype")
        encoder.encodeObject(self.id, forKey: "kid")
        encoder.encodeObject(self.shufflegroup, forKey: "kshufflegroup")
        encoder.encodeObject(self.displayName, forKey: "kdisplayName")
        encoder.encodeObject(self.displayText, forKey: "kdisplayText")
        encoder.encodeObject(self.displayImage, forKey: "kdisplayImage")
        encoder.encodeObject(self.tags, forKey: "ktags")
        encoder.encodeObject(self.question, forKey: "kquestion")
    }
    
    func addTag(tag:AHTag) {
        tags.append(tag);
    }

}